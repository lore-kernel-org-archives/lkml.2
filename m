Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2GNRcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 13:32:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46411 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2GNRcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 13:32:39 -0400
Date: Sat, 14 Jul 2012 19:32:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Davidlohr Bueso <dave@gnu.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, amd: rename vmmu support capability
Message-ID: <20120714173236.GA32400@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Davidlohr Bueso <dave@gnu.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
	kvm list <kvm@vger.kernel.org>, x86@kernel.org
References: <1342202575.2706.4.camel@offbook>
 <20120714101951.GB26559@liondog.tnic>
 <0ffa7987-66fd-4c8d-85da-9911eee3eeaf@email.android.com>
 <1342276131.2956.6.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342276131.2956.6.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 04:28:51PM +0200, Davidlohr Bueso wrote:
> On Sat, 2012-07-14 at 15:38 +0200, H. Peter Anvin wrote:
> > Yep, NAK on this one.
> 
> Ok, we could at least add a comment when defining X86_FEATURE_NPT.

And the valid, sane, technical reason for having a comment where any
internet search could do, is... ?

-- 
Regards/Gruss,
    Boris.
