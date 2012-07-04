Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2GDOOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:14:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39671 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2GDOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:14:15 -0400
MIME-Version: 1.0
In-Reply-To: <4FF43BBE.80201@spin.net.au>
References: <4FF43BBE.80201@spin.net.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 4 Jul 2012 08:13:53 -0600
Message-ID: <CAErSpo6jdzPZYmtggETE-6k2jRLB7db8t68jQ92GRb1yFSto2g@mail.gmail.com>
Subject: Re: Kernel official involvement
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 6:49 AM, Chris Jones <chrisjones@spin.net.au> wrote:
> I am just wondering how does anyone get further involved with Linux kernel
> development? How do you get selected to be able to push through patches etc.
> to the official kernel? Who authorizes who to be able to do so?

Anyone can write and post kernel patches.  There is not really a
concept of "people authorized to push patches."  In Linux, Linus
*pulls* patches that he thinks are useful.  He generally pulls patches
from maintainers of various areas, who have already reviewed them and
decided they are worthwhile.  So you just have to convince the
maintainer of the area you're changing that your patch is correct and
useful.  Here are some good hints about how to get started:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/SubmittingPatches;h=c379a2a6949f1c1cac04fb6f185c633512f37061;hb=HEAD
