Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0JKXjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:39:10 -0400
Received: from smtp6.freeserve.com ([193.252.22.192]:24999 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0JKXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:39:08 -0400
X-ME-UUID: 20101011233905935.E469A7000092@mwinf3624.me.freeserve.com
Date: Tue, 12 Oct 2010 00:38:38 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Len Brown <lenb@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Lenovo S12 2.6.36-rc7 lockup
Message-ID: <20101012003838.57eaba51@boulder.homenet>
In-Reply-To: <20101012002731.3226d5be@boulder.homenet>
References: <20101010135912.76eb61b7@boulder.homenet>
	<alpine.LFD.2.00.1010111810530.3341@localhost.localdomain>
	<20101012002731.3226d5be@boulder.homenet>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 00:27:31 +0100
Chris Vine <chris@cvine.freeserve.co.uk> wrote:
[snip]
> However, playing around with this has revealed that if I keep my
> finger continuously on a keyboard key (Ctrl or Alt are obviously good
> choices as they don't of themselves input anything) causes the
> notebook to behave more or less normally.  However, as soon as the
> key is released it goes into some kind of sleep state.  It looks as
> if it might be some kind of ACPI issue.

And blacklisting intel_ips doesn't help either.

Chris


