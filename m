Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0HCCoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:44:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46870 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0HCCod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:44:33 -0400
MIME-Version: 1.0
In-Reply-To: <20100802.160057.91342787.davem@davemloft.net>
References: <1280776623-1337-1-git-send-email-wad@chromium.org>
	<20100802.160057.91342787.davem@davemloft.net>
Date: Mon, 2 Aug 2010 21:44:31 -0500
Message-ID: <AANLkTi=f1nv9fUVPRxAgaEFbEKS5nvCLaQTtQ3x=BT_v@mail.gmail.com>
Subject: Re: [PATCH RFC] efi: add and expose efi_partition_by_guid
From: Will Drewry <wad@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kzak@redhat.com, tj@kernel.org,
        akpm@linux-foundation.org, joe@perches.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 6:00 PM, David Miller <davem@davemloft.net> wrote:
> From: Will Drewry <wad@chromium.org>
> Date: Mon,  2 Aug 2010 14:17:03 -0500
>
>> +int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid) {
>
> Please put the openning brace on a new line.

Thanks! I'll post a new version with that fixed as well as the
alternative approach I mentioned.

cheers!
will
