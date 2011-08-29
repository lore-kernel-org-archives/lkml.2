Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1H2Rvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:51:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50760 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1H2Rvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:51:45 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kyle Moffett <kyle@moffetthome.net>, Alex Deucher <alexdeucher@gmail.com>,
        Pavel Ivanov <paivanof@gmail.com>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 29 Aug 2011 19:51:33 +0200
In-Reply-To: <20110829172146.GE2025@gere.osrc.amd.com>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
	 <1314435638.2321.12.camel@thor.local>
	 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
	 <20110828053624.GC12851@liondog.tnic> <1314624021.2816.30.camel@twins>
	 <20110829133808.GA2025@gere.osrc.amd.com>
	 <CADnq5_Mppeym2spCqsRGYALQxWDjQ_yNuta4SYRH6Oocy=UjSg@mail.gmail.com>
	 <CAGZ=bqKHvauaW8jdPR98d-X5dry_pADYHWH-OsJE_CXT9hdwVw@mail.gmail.com>
	 <20110829172146.GE2025@gere.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314640293.2816.119.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 19:21 +0200, Borislav Petkov wrote:
> 
> Yeah, sounds much better than Kconfig actually aiding and abetting
> firmware blobs in the kernel and users needing to do stuff.
> 
I would very much like to retain that option.. and having to manually
figure out what blob goes with what driver just isn't fun.


