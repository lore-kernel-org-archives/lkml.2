Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1JPSG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:06:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab1JPSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:06:28 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=oe0lC-8eqlkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=b8VgSBC0AAAA:8 a=73W8XSPajJvKvDyw9_sA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318788387.12224.126.camel@gandalf.stny.rr.com>
Subject: Re: Problems with videos and i915 driver
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: dri-devel@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Date: Sun, 16 Oct 2011 14:06:27 -0400
In-Reply-To: <1318788068.12224.125.camel@gandalf.stny.rr.com>
References: <1318788068.12224.125.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 14:01 -0400, Steven Rostedt wrote:

> For the full dmesg:
> 
> http://rostedt.homelinux.com/private/vid-crash/dmesg

Another clue that looks nasty is this line:

[    0.427196] pci_root PNP0A08:00: address space collision: host bridge window [mem 0x000c8000-0x000dffff] conflicts with Video ROM [mem 0x000c0000-0x000cd7ff]

-- Steve


