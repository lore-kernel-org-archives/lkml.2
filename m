Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0GOLcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 07:32:31 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38384 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0GOLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 07:32:30 -0400
Date: Thu, 15 Jul 2010 07:32:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: linux-input@vger.kernel.org
Subject: any value in running my kernel scanning scripts before release?
Message-ID: <alpine.DEB.2.00.1007150728520.13042@lynx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
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


  normally i wait for the merge window, then run my kernel scanning
scripts and post results.  any interest in me doing that earlier?  i
just did a quick test and found a number of incongruities like, for
example:

$ grep -r "config QT2160" *
drivers/input/keyboard/Kconfig:config QT2160
$

$ grep -r KEYBOARD_QT2160 *
drivers/input/keyboard/Makefile:obj-$(CONFIG_KEYBOARD_QT2160) += qt2160.o
$

  which is a fairly obvious mismatch between the config variable and
the test, yes?

  anyway, i'm open to suggestions.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
