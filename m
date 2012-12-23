Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2LWLXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:23:49 -0500
Received: from mx-out.ukfsn.org ([77.75.108.125]:40773 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751590Ab2LWLXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:23:47 -0500
Message-ID: <50D6E491.3030801@ukfsn.org>
Date: Sun, 23 Dec 2012 11:01:37 +0000
From: Andy Furniss <andyqos@ukfsn.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
References: <20121222203547.GA5319@liondog.tnic> <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com> <20121223002507.GA12121@liondog.tnic> <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com> <20121223105527.GA6230@liondog.tnic>
In-Reply-To: <20121223105527.GA6230@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:

> [   28.191072] radeon: `0' invalid for parameter `wb'
>
> although the whole driver blubber didn't appear on the console fterwards
> aso something got turned off allright.
>
> Then, I went and tried "radeon.no_wb" where the driver blubber appeared
> but AGP writeback was still enabled:

no_wb=1 should work.


