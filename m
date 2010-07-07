Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0GGXmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:42:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281Ab0GGXma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:42:30 -0400
Date: Wed, 7 Jul 2010 16:41:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 16/26] fbdev: Add JZ4740 framebuffer driver
Message-Id: <20100707164148.d2a1f8c4.akpm@linux-foundation.org>
In-Reply-To: <4C310ACD.6040604@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
	<1276924111-11158-17-git-send-email-lars@metafoo.de>
	<4C310ACD.6040604@metafoo.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jul 2010 00:27:25 +0200
Lars-Peter Clausen <lars@metafoo.de> wrote:

> Hi Andrew
> 
> v2 of this patch has been around for two weeks without any comments. I've fixed all
> the issues you had with v1. If you this version is ok, an Acked-By would be nice :)

I don't do acks - I already have enough to be blamed for.  I'd merge it
if asked to though.  Although I might whine about inappropriate use of
ENOENT, which means "No such file or directory".

