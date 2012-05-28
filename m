Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2E1KKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:10:55 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46107 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2E1KKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120528133540.19498993351d66f959f079b6@canb.auug.org.au>
References: <20120528133540.19498993351d66f959f079b6@canb.auug.org.au>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 28 May 2012 18:10:32 +0800
Message-ID: <CAO_48GGkMemXg2nMiU5y-Kb3BJPVP6adY+dtCUDKJV9U+7bo-A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the dma-buf tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2012 11:35, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sumit,
Hi Stephen,
>
> Today's linux-next merge of the dma-buf tree got conflicts in
> drivers/base/dma-buf.c and include/linux/dma-buf.h between various
> commits from Linus' tree and various commits from the dma-buf tree.
>
> Again, another tree that was rebased before or after being sent
> upstream.  Please don't do this.
My apologies - I have updated this tree now, and you won't see this
problem going forward.
>
> I have used the versions of these files from Linus' tree.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

Thanks and regards,
Sumit
