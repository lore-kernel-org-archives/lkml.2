Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab2LWLcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:32:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38952 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab2LWLb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:31:57 -0500
Date: Sun, 23 Dec 2012 12:31:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Furniss <andyqos@ukfsn.org>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20121223113153.GA8918@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andy Furniss <andyqos@ukfsn.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20121222203547.GA5319@liondog.tnic>
 <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
 <20121223002507.GA12121@liondog.tnic>
 <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
 <20121223105527.GA6230@liondog.tnic>
 <50D6E491.3030801@ukfsn.org>
 <20121223110730.GC6230@liondog.tnic>
 <50D6E8A4.1030204@ukfsn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50D6E8A4.1030204@ukfsn.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 11:19:00AM +0000, Andy Furniss wrote:
> modinfo radeon
> 
> will give a list assuming you use modules, I think all of them need =<num>.

Yep, that is one way of getting that info, thanks. I always go and look
at Documentation/kernel-parameters.txt and forget about modinfo.

As you say 'radeon' needs to be module but since this is the case with
the distros, the majority of Linux installations out there have it this
way so we're fine.

Btw, there's a typo in the param list, if anyone wants to write a patch
for it :-):

parm:           lockup_timeout:GPU lockup timeout in ms (defaul 10000 = 10 seconds, 0 = disable) (int)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
