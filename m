Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1FCJZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:25:16 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:36626 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1FCJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:25:13 -0400
Message-ID: <20110603112510.18482vx63j4ygmm8@webmail.df.eu>
Date: Fri, 03 Jun 2011 11:25:10 +0200
From: michael@m-bauer.org
To: simon@mungewell.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v2] hid: Fix Logitech Driving Force Pro wheel
References: <2b85316d7925dad6c55672d7d9738e18.squirrel@host171.canaca.com>
In-Reply-To: <2b85316d7925dad6c55672d7d9738e18.squirrel@host171.canaca.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Originating-IP: 212.63.94.234
X-Df-Sender: 503602
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Changes from initial patch:
>> - shorten comment (removed original descriptor)
>> - optimized new descriptor (simpler and shorter)
>
> Concept looks go to me, but I'm getting
> --
> simon@ubuntu:~/linux-2.6$ patch -p 1 <
> ../Downloads/v2-hid-Fix-Logitech-Driving-Force-Pro-wheel.patch
> patching file drivers/hid/hid-lg.c
> patch: **** malformed patch at line 91: USB_DEVICE_ID_LOGITECH_G25_WHEEL), --
>
> Looks like word wrap has been applied to the patch.
>
> It also fails to patch chunk 3 against 3.0rc1 as the G27 wheel has been
> added.
> [...]

Ouch, seems i messed that up :-/

> All that said it appears to build (don't have this wheel to test) and have
> it in a git archive if you'd like be to spin a fixed patch for you.

Simon, it would be great if you could do this - I am quite busy at work
atm :-( If not let me know, then I'll try to squeeze it in on my side.

Thank you and best regards
Michael




