Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1HWAKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:10:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:9550 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1HWAKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40776145"
Message-ID: <4E52EFE6.5020004@linux.intel.com>
Date: Mon, 22 Aug 2011 17:10:14 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>
CC: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] VFS: Add generic_file_llseek_size
References: <1314046152-2175-1-git-send-email-andi@firstfloor.org> <1314046152-2175-5-git-send-email-andi@firstfloor.org> <CA5160B4-09CC-4B0D-9AB1-1F946D02B379@dilger.ca>
In-Reply-To: <CA5160B4-09CC-4B0D-9AB1-1F946D02B379@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think your commit comment is incorrect.  It should read:
>
> Add a generic_file_llseek_size() variant to the VFS that allows passing
> in the maximum file size, instead of always using inode->i_sb->s_maxbytes.
> This can be used to eliminate some cut'n'paste seek code in ext4.
>
> Also, the function prototype in fs.h should take "loff_t maxbytes" instead
> of "loff_t size".

Yes you're right. Will fix.

Thanks for the review.

-Andi


