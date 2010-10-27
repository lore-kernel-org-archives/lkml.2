Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab0J0IIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:08:52 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:52499 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0J0IIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:08:50 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4CC7DDCC.7040605@elka.pw.edu.pl>
Date: Wed, 27 Oct 2010 10:07:40 +0200
From: Wojtek Zabolotny <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: More details - Re: i915 module with modeset=1 freezes machine (kernels
 2.6.33 and 2.6.36)
References: <4CC751E8.9030505@elektron.elka.pw.edu.pl>
In-Reply-To: <4CC751E8.9030505@elektron.elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tried to boot my desktop machine (chipset 82865G with agpgart and 
i915 compiled into kernel) with i915.modeset=0
In this case machine works, but X work only with vesa driver.

Browsing reports about similar problems I have found suggestion to use 
i915.modeset=1 i915.powersave=0
unfortunately this also leads to black screen and freeze of machine.

In my laptop machine (chipset 945GM with agpgart and intel_agp and i915 
compiled as modules), when I reload i915 with modeset=1 it causes 
immediate black screen and freeze (the value of powersave parameter does 
not change the behaviour of my system).

I have also found some info that the problem may be related to detection 
of lid switch (in laptop) - I tried to press and release the lid switch 
in my laptop machine - this switched the backlight on, but system was 
still frozen and unaccessible.


