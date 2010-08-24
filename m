Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab0HXUc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:32:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42268 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328Ab0HXUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:32:53 -0400
Subject: Re: [PATCH v2] guard page for stacks that grow upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-ia64@vger.kernel.org,
        John David Anglin <dave.anglin@nrc-cnrc.gc.ca>,
        Kyle McMartin <kyle@parisc-linux.org>
In-Reply-To: <AANLkTinMbTu6H9m70sapfpGHC4secUsaUqZKkg_=CWA6@mail.gmail.com>
References: <4c7413025613b269c@agluck-desktop.sc.intel.com>
	 <AANLkTinMbTu6H9m70sapfpGHC4secUsaUqZKkg_=CWA6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 20:32:48 +0000
Message-ID: <1282681968.2993.109.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 13:19 -0700, Linus Torvalds wrote:
> On Tue, Aug 24, 2010 at 11:44 AM, Luck, Tony <tony.luck@intel.com> wrote:
> >
> > Built, booted & tested on ia64
> > Built for x86_64 (but not booted or tested)
> > pa-risc - untested
> 
> Ok, applied. I do think we could do the "VM_GROWSDOWN = 0" trick for
> PA-RISC  (so that the code for the growsdown case would be compiled
> away there), but that definitely needs somebody who actually cares
> specifically about PA-RISC.

I can try it ... I was just getting ready to try the -rc2 kernel on our
cupertino test ring anyway.

James


