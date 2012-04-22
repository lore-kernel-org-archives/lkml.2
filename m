Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab2DVJRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 05:17:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42732 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2DVJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 05:17:53 -0400
MIME-Version: 1.0
Date: Sun, 22 Apr 2012 11:17:52 +0200
Message-ID: <CAB_4oTV5y0k+9y1hvUgeAFQ-p2XGhjZQn8g34uEaiwfMXXiA-w@mail.gmail.com>
Subject: What determines compatibility of module_layout?
From: Johan Gill <johan.gill@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to build a kernel module for a kernel for which I don't
have the source code (and let's currently ignore the license violation
the provider is doing).

In order to understand better how to make this module fit into the
kernel, I would need to know what determines compatibility of the
module_layout symbol.

>From the standard sources, I've managed to understand that the layout
of struct module, struct modversion_info, struct kernel_param, struct
kernel_symbol and struct tracepoint is important.

As I have access to /proc/config.gz, I made sure the config parameters
that affect these structures are set accordingly. I also use the same
gcc version, and name the kernel version the same way (2.6.34-VENUS).
That is however not enough, so in order to understand what is wrong, I
would need to know: In the standard kernel, is having the above
mentioned structures compatible enough for having compatible
module_layout symbols, and am I missing what structure compatiblity
really requires?

I use linux-mips to compile the module, but I believe these questions
should be general enough for this list.

/Johan Gill
