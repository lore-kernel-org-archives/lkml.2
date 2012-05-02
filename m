Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2EBGmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:42:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36155 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2EBGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:42:40 -0400
Date: Tue, 1 May 2012 22:10:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 06/19] PCI: prepare for serializing hotplug operations
 triggered by pciehp driver
Message-ID: <20120502051027.GD23579@kroah.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
 <1335539820-11232-7-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335539820-11232-7-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:16:47PM +0800, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Split pciehp_wq into two workqueues to avoid possible deadlock issues
> when using PCI hotplug lock to serialize hotplug operations triggered
> by pciehp driver.

Why two workqueues?  What is deadlocking?  And why name one "power" and
one "event"?  What do they now do differently?  How are you serializing
events across the workqueues as they can be doing the same thing at the
same time to the same hardware now, right?

What am I missing?

Ick, I said I wasn't going to read anymore, I'm really stopping now.
Sorry, it's like watching a train-wreck, you just can't turn away...

greg k-h
