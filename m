Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1EITVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:21:18 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60671 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754039Ab1EITVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:21:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LGPBLbbdQdMA1rpuq1Cjd5x70IGxx4zyCgs/UJIA44srzCiYWbCZcZyTZUc1wwq5rKZzkxOc0THatas3h3crjFp7M96XSpxA2bb9aHh8QVsFNhdmb+K4nkjmAZAyG5XV;
Date: Mon, 9 May 2011 12:20:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jianyun Li <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, Jianyun Li <jyli@marvell.com>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list),
        linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
Subject: Re: [PATCH v2] Add Marvell UMI driver
Message-ID: <20110509122051.33f1672f@jbarnes-desktop>
In-Reply-To: <1304943577-2876-1-git-send-email-jianyunff@gmail.com>
References: <Message-Id>
	<1304943577-2876-1-git-send-email-jianyunff@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 May 2011 20:19:33 +0800
Jianyun Li <jianyunff@gmail.com> wrote:

> 	The Marvell Universal Message Interface (UMI) defines a messaging
> interface between host and Marvell products (Plato, for example). It
> considers situations of limited system resource and optimized system
> performance.
> 	UMI driver translates host request to message and sends message
> to FW via UMI, FW receives message and processes it, then sends response
> to UMI driver.
> 	FW generates an interrupt when it needs to send information or
> response to UMI driver
> 

Unless you're using the PCI ID outside of this driver, you can just put
it in your header file rather than pci_ids.h, which is meant for IDs
that are shared between modules.

-- 
Jesse Barnes, Intel Open Source Technology Center
