Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab0FBQiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:38:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23002 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab0FBQiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=aL5RdQO4REJFRZtGL/zVFTPDnAF2ue0PtD7jbvKUuxFTKvtJxM9kxSQG+pMgrz8cHO
         57JNaa73v3p2FqFfw0NOSJoY6FJyfe9IdevVTSC4VIPWiJf17A3jsergwuJWPnJ2XtXP
         o0uiKCrZHAgM2uj1od1GSbAzwUo4AKu0Rgv94=
Message-ID: <4C0688E5.3010902@gmail.com>
Date: Wed, 02 Jun 2010 18:37:57 +0200
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
>  0001-buffer-make-invalidate_bdev-drain-all-percpu-LRU-add.patch
>  0002-block-restart-partition-scan-after-resizing-a-device.patch
>  0003-block-ide-simplify-bdops-set_capacity-to-unlock_nati.patch
>  0004-block-use-struct-parsed_partitions-state-universally.patch
>  0005-block-improve-automatic-native-capacity-unlocking.patch
>  0006-SCSI-implement-sd_unlock_native_capacity.patch
>  0007-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
>  0008-libata-implement-on-demand-HPA-unlocking.patch

Jeff, now 0001-0005 are in mainline.  Can you please apply 0006-0008?

Thanks.

-- 
tejun
