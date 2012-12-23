Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2LWLTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:19:06 -0500
Received: from mx-out.ukfsn.org ([77.75.108.125]:40063 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082Ab2LWLTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:19:04 -0500
X-Greylist: delayed 1043 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2012 06:19:04 EST
Message-ID: <50D6E8A4.1030204@ukfsn.org>
Date: Sun, 23 Dec 2012 11:19:00 +0000
From: Andy Furniss <andyqos@ukfsn.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
References: <20121222203547.GA5319@liondog.tnic> <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com> <20121223002507.GA12121@liondog.tnic> <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com> <20121223105527.GA6230@liondog.tnic> <50D6E491.3030801@ukfsn.org> <20121223110730.GC6230@liondog.tnic>
In-Reply-To: <20121223110730.GC6230@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Sun, Dec 23, 2012 at 11:01:37AM +0000, Andy Furniss wrote:
>> no_wb=1 should work.
>
> Yeah, maybe all those radeon and other GPU module parameters' syntax
> should be documented somewhere - Documentation/kernel-parameters.txt for
> example, or a GPU-specific file, whatever - so that we can save us all
> the time and confusion. Provided this hasn't happened yet, of course.

modinfo radeon

will give a list assuming you use modules, I think all of them need =<num>.


