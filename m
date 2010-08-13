Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab0HMNOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:14:35 -0400
Received: from centrinvest.ru ([94.25.115.130]:51977 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761578Ab0HMNOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:14:33 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Fri, 13 Aug 2010 17:14:22 +0400
To: bchociej@gmail.com
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
        crscott@us.ibm.com, mlupfer@gmail.com, conscott@vt.edu
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Message-ID: <20100813131422.GA615@centrinvest.ru>
Mail-Followup-To: bchociej@gmail.com, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com, mlupfer@gmail.com,
	conscott@vt.edu
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281652177-23562-3-git-send-email-bchociej@gmail.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
> From: Ben Chociej <bchociej@gmail.com>
> 
> Modified mkfs.btrfs to add hot data relocation option (-h) which
> preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
> BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot data
> relocation code.  Also added a userspace function to detect whether a
> block device is an SSD by reading the sysfs block queue rotational flag.

IMHO this policy is too inflexible. What if I have large array of slow SATA 
disks and some fast SAS ones ?
