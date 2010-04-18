Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0DRUI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 16:08:58 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39655 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0DRUI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 16:08:56 -0400
Date: Sun, 18 Apr 2010 16:06:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: is there any chance of cleaning up the "inline" chaos?
Message-ID: <alpine.LFD.2.00.1004181605220.4775@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  i mean, how many different definitions of inline are necessary?

#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
# define inline         inline          __attribute__((always_inline))
# define __inline__     __inline__      __attribute__((always_inline))
# define __inline       __inline        __attribute__((always_inline))
#endif

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
