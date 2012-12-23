Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2LWLHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:07:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37115 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab2LWLHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:07:33 -0500
Date: Sun, 23 Dec 2012 12:07:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Furniss <andyqos@ukfsn.org>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20121223110730.GC6230@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50D6E491.3030801@ukfsn.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 11:01:37AM +0000, Andy Furniss wrote:
> no_wb=1 should work.

Yeah, maybe all those radeon and other GPU module parameters' syntax
should be documented somewhere - Documentation/kernel-parameters.txt for
example, or a GPU-specific file, whatever - so that we can save us all
the time and confusion. Provided this hasn't happened yet, of course.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
