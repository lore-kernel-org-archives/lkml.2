Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1EPUbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:31:51 -0400
Received: from relais.videotron.ca ([24.201.245.36]:32836 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1EPUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:31:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 16 May 2011 16:31:49 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Andrew Lunn <andrew@lunn.ch>
Cc: kernel@wantstofly.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, saeed.bishara@gmail.com
Subject: Re: [PATCHv2 00/15] Consolidate Orion platform information setup.
In-reply-to: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Message-id: <alpine.LFD.2.00.1105161608340.14430@xanadu.home>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011, Andrew Lunn wrote:

> This patchset consolidates some of the code used for creating
> platform data for various orion based SoC, namely Dove, Loki, Kirkwood,
> mv78xx0 and Orion5x. Where possible, this code has been put into the
> orion platform, with the mach-*/common.c calling the common platform
> code.
> 
> Additionally the setup of the multi purpose pins has been consolidated.
> Kirkwood and mv78xx0 had identical code, which has been generalized and
> put into the platform. Orion5x and Dove mpp code has been re-written to 
> use the consolidated method.
> 
> Tested on a Kirkwood device, otherwise compile tested.
> 
> Changes since last version:
> 
>  - Typos found by Saeed Bishara fixed
>  - All ethernets reserve the same size
>  - Add Kirkwood RTC interrupt as a seperate patch
>  - Rather than drop the dove mpp code, refactor to use the platform code.

This looks great. Thanks for this work. That will certainly make any 
transition to device tree much simpler.

Some further consolidation could be achieved by dynamically allocating 
the platform device structures as needed and having a single function 
for each class of devices.  But that can be done in a subsequent series.


Nicolas
