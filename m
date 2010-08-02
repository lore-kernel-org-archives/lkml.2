Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0HBXAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:00:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56412
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab0HBXAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:00:39 -0400
Date: Mon, 02 Aug 2010 16:00:57 -0700 (PDT)
Message-Id: <20100802.160057.91342787.davem@davemloft.net>
To: wad@chromium.org
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, kzak@redhat.com,
        tj@kernel.org, akpm@linux-foundation.org, joe@perches.com
Subject: Re: [PATCH RFC] efi: add and expose efi_partition_by_guid
From: David Miller <davem@davemloft.net>
In-Reply-To: <1280776623-1337-1-git-send-email-wad@chromium.org>
References: <1280776623-1337-1-git-send-email-wad@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>
Date: Mon,  2 Aug 2010 14:17:03 -0500

> +int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid) {

Please put the openning brace on a new line.
