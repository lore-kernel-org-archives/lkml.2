Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0KIVaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:30:19 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49201 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0KIVaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:30:17 -0500
Date: Tue, 9 Nov 2010 22:29:23 +0100
From: Borislav Petkov <bp@amd64.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: AMD boot freeze bisected to
 b126b4703afa4010b161784a43650337676dd03b
Message-ID: <20101109212923.GA5415@aftab>
References: <20101102170335.GC24927@aftab>
 <201011092132.45442.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011092132.45442.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 03:32:45PM -0500, Maciej Rutecki wrote:
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=22552
> for your bug report, please add your address to the CC list in there, thanks!

You didn't have to - Bjorn already did that:
https://bugzilla.kernel.org/show_bug.cgi?id=22062

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
