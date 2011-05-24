Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab1EXA3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:29:09 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1798 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1EXA3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:29:04 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
To: "Greg KH" <greg@kroah.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 May 2011 17:28:54 -0700
Subject: RE: [GIT PATCH] STAGING pull for .40
Thread-Topic: [GIT PATCH] STAGING pull for .40
Thread-Index: AcwZnXPh8CSULbFwTdi6/UFUenFjzgACnXWA
Message-ID: <400C43189542CE41BC0A5B252FC90136A8E6853B13@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20110523193855.GA20384@kroah.com>
 <BANLkTi=vUXOfZ57CT7CtAjOzYReBnp=Vvg@mail.gmail.com>
 <20110523230033.GA26471@kroah.com>
In-Reply-To: <20110523230033.GA26471@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 61C423361IC11082701-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 04:01 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, May 23, 2011 at 01:43:13PM -0700, Linus Torvalds wrote:
> > which looks like another case of "can't compile two things both into
> > the kernel".
> >
> > Looks like the BRCMSMAC / BRCMFMAC drivers need to be mutually
> > exclusive. Something like
> >
> >   depends on m || (BRCMSMAC != y)
> >
> > for BRCMFMAC?
> >
> > Or they should just avoid using the same globally visible name.
> 
> Both probably.  I'll fix this up for the next set of staging fixes
> after
> you release -rc1.

Sorry about this. We have never compiled both modules with yesconfig to check for coexistence issue. We will add this to checklist from now on. And there should not be any coexistence problem for brcmsmac and brcmfmac. I will send out a patch for fixing this today.

Thanks,
Franky

