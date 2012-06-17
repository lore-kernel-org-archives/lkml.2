Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2FQQfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 12:35:14 -0400
Received: from 1wt.eu ([62.212.114.60]:3320 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab2FQQfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 12:35:13 -0400
Date: Sun, 17 Jun 2012 18:35:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.5 regressions related to printk changes
Message-ID: <20120617163509.GK8450@1wt.eu>
References: <20120617150928.GJ8450@1wt.eu> <20120617155452.GA18966@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120617155452.GA18966@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sun, Jun 17, 2012 at 08:54:52AM -0700, Greg Kroah-Hartman wrote:
> Try the patch below, which is in my set of patches to go to Linus soon
> and let me know if it works or not.
> 
> thanks,
> 
> greg k-h
> 
> 
> From 6ebb017de9d59a18c3ff9648270e8f6abaa93438 Mon Sep 17 00:00:00 2001
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Tue, 5 Jun 2012 08:52:34 +0200
> Subject: printk: Fix alignment of buf causing crash on ARM EABI
(...)

Perfect, works like a charm !

Thanks!
Willy

