Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0GHQr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:47:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab0GHQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:47:25 -0400
Date: Thu, 8 Jul 2010 09:46:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 16/26] fbdev: Add JZ4740 framebuffer driver
Message-Id: <20100708094654.6fbeefe8.akpm@linux-foundation.org>
In-Reply-To: <4C35D264.7080809@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
	<1276924111-11158-17-git-send-email-lars@metafoo.de>
	<4C310ACD.6040604@metafoo.de>
	<20100707164148.d2a1f8c4.akpm@linux-foundation.org>
	<4C35D264.7080809@metafoo.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010 15:28:04 +0200 Lars-Peter Clausen <lars@metafoo.de> wrote:

> > Although I might whine about inappropriate use of
> > ENOENT, which means "No such file or directory".
> > 
> 
> That is due to to many bad examples, I guess. Would using ENXIO instead keep
> you from whining?

Sounds a bit better.  It's hardly a huge issue though.
