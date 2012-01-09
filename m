Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab2AIXHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:07:38 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37784 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932589Ab2AIXHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:07:37 -0500
X-Sasl-enc: JjhM+KKHPB+VbhiHjPQfwg0aL8hghhLtIMomJba0l47N 1326150456
Date: Mon, 9 Jan 2012 15:07:28 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
Message-ID: <20120109230728.GA11732@kroah.com>
References: <1325951076.860.2.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325951076.860.2.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 04:44:36PM +0100, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: modules: sysfs - export taint, address, size
> 
> Recent tools do not use /proc to retrieve module information. A few values
> are currently missing from sysfs.
> 
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  kernel/module.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------

You forgot the Documentation/ABI/ update as well :)

