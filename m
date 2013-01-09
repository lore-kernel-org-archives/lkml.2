Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab3AIChC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:37:02 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:56958 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3AIChA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:37:00 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Wed, 9 Jan 2013 03:36:44 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Supporting SYSRQ on broken laptops like the thinkpad T530
Message-ID: <20130109023643.GA7066@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Marc MERLIN <marc@merlins.org>,
	Linux Kernel mailing List <linux-kernel@vger.kernel.org>
References: <20130108230954.GN2044@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130108230954.GN2044@merlins.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-08 Tuesday at 15:09 -0800 Marc MERLIN wrote:
> In its infinite wisdom, lenovo has removed the sysrq key on the latest
> thinkpads, and replaced it with a stupid ALT+FN+S key combination, which
> doesn't really work for doing sysrq from the console (nor do I know how the
> genius who did that intended for SYSRQ-S to work).
> http://forums.lenovo.com/t5/T400-T500-and-newer-T-series/T430-s-T530-Where-are-the-shortcut-function-keys-break-Pause-etc/ta-p/781749
> 
> I realize that one solution is to throw my laptop window at a suitable high
> floorand replace it with one from a vendor that doesn't randomly remove keys
> from the keyboard.
> That said, I was wondering if there were other solutions, especially
> considering that thinkpads used to be the better linux laptops.

My Dell “Precision M4500” notebook suffers similar (same?) problem.  So far 
I could not find a solution better than this:  e.g. Alt-Fn-SysRq-s

press and hold Alt
press and hold Fn
press and leave F10|SysRq
leave Fn
press and leave s
leave Alt

Several months ago a LKML user claimed, his cat had managed to press 
Alt-Fn-SysRq-c on his Dell Latitude notebook with similar keyboard, and provided 
photos showing the kernel crash message ;)

-- 
Roland
