Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3AHAJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:09:53 -0500
Received: from plane.gmane.org ([80.91.229.3]:40688 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab3AHAJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:09:52 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Maurizio Avogadro <mavoga@gmail.com>
Subject: Re: [3.6.9 -> 3.7.1 regression] sound: =?utf-8?b?c25kX2hkYV9pbnRlbA==?= codec probing issue?
Date: Tue, 8 Jan 2013 00:04:25 +0000 (UTC)
Message-ID: <loom.20130108T005050-419@post.gmane.org>
References: <1356704740.3953.26.camel@lamella> <s5hvcber5cz.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 93.42.35.78 (Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 Iceweasel/17.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai <at> suse.de> writes:

> 
> [...]
> 
> If it's new in 3.7, this could be a regression by runtime D3.
> Try to pass power_save_controller=0 option to snd-hda-intel module
> (or change it via sysfs dynamically).
> 
> thanks,
> 
> Takashi


Hi Takashi

same codec here (ALC269VB on a Clevo W150HRM), same kernel, same issue.
Disabling power_save_controller solves the issue, but I could achieve the same
result by setting enable_msi=0, which I chose in the hope to preserve power
saving capabilities.

thanks, Maurizio

