Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0ESHFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:05:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0ESHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kpNkwLAmE4ifI3s/Mfq8aqe4ce772e01ntKHhpR6uR05PQG16EWanCcY+N1RtdlPZl
         4WqDelOwsSnwIpI9sRUlE53aCvQ7zIArw7euYf8TLj68R8ZR5RyELSZ5Ww9Qj4cstUIu
         NdBhQVaSDnyZyON7KGAy5M1BFtMSaB66NBjno=
Message-ID: <4BF38DC4.3090900@gmail.com>
Date: Wed, 19 May 2010 09:05:40 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net,
       bzolnier@gmail.com
Subject: Re: [PATCHSET] block,libata: implement ->unlock_native_capacity()
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2010 08:09 PM, Tejun Heo wrote:
> Hello, all.
> 
> This is the evolved version of the implement-set_capacity patchset[L]
> and contains the following patches.
> 
>  0001-buffer-make-invalidate_bdev-drain-all-percpu-LRU-add.patch
>  0002-block-restart-partition-scan-after-resizing-a-device.patch
>  0003-block-ide-simplify-bdops-set_capacity-to-unlock_nati.patch
>  0004-block-use-struct-parsed_partitions-state-universally.patch
>  0005-block-improve-automatic-native-capacity-unlocking.patch
>  0006-SCSI-implement-sd_unlock_native_capacity.patch
>  0007-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
>  0008-libata-implement-on-demand-HPA-unlocking.patch

Other than block part, everything is acked, so how do we route this?
0001-0005 through block tree and 0006-0008 through libata tree seem
the easiest unless someone objects.  Jens, can you please review
0001-0005 and take them into block tree if it seems okay?

Thanks.

-- 
tejun
