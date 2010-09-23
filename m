Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0IWWCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:02:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab0IWWCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:02:20 -0400
Date: Thu, 23 Sep 2010 15:01:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Balaji Rao <balajirrao@openmoko.org>,
        Paul Fertser <fercerpav@gmail.com>
Subject: Re: [PATCH] drivers/power: add missing sysfs_remove_group() in
 pcf50633_mbc_remove()
Message-Id: <20100923150133.c03ce2d7.akpm@linux-foundation.org>
In-Reply-To: <20100922121658.GA24829@oksana.dev.rtsoft.ru>
References: <1285058157.26315.1.camel@mola>
	<20100922121658.GA24829@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 16:16:58 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> On Tue, Sep 21, 2010 at 04:35:57PM +0800, Axel Lin wrote:
> > sysfs entries should be removed when unload the module.

I suspect this patch fixes a kernel crash, yes?

> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Applied, thanks!

Please consider backporting it into earlier kernels too.  Preferably done
by adding a Cc: <stable@kernel.org> to the changelog.

