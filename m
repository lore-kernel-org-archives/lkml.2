Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0IHBrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:47:37 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35614 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0IHBrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:47:32 -0400
Message-ID: <4C86EAE7.607@ct.jp.nec.com>
Date: Wed, 08 Sep 2010 10:46:15 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, mpatocka@redhat.com
Subject: Re: [PATCH 24/41] dm: implement REQ_FLUSH/FUA support for request-based
 dm
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-25-git-send-email-tj@kernel.org>
In-Reply-To: <1283509796-1510-25-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 09/03/2010 07:29 PM +0900, Tejun Heo wrote:
> This patch converts request-based dm to support the new REQ_FLUSH/FUA.

I reviewed this patch and found no obvious problem.
Also, I tested this patch series using request-based dm-multipath +
ext3/ext4 and found no problem.

Tested-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Thanks,
Kiyoshi Ueda
