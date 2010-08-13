Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403Ab0HMORv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:17:51 -0400
Received: from 193-34-3-90.chelmnet.pl ([193.34.3.90]:41243 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0HMORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:17:48 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2010 10:17:48 EDT
Date: Fri, 13 Aug 2010 16:08:10 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bchociej@gmail.com, chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
        cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
        crscott@us.ibm.com, mlupfer@gmail.com, conscott@vt.edu
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Message-ID: <20100813140810.GB24029@mother.pipebreaker.pl>
Mail-Followup-To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	bchociej@gmail.com, chris.mason@oracle.com,
	linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com, mlupfer@gmail.com,
	conscott@vt.edu
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com>
 <20100813131422.GA615@centrinvest.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813131422.GA615@centrinvest.ru>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 05:14:22PM +0400, Andrey Panin wrote:
> On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
> > From: Ben Chociej <bchociej@gmail.com>
> > 
> > Modified mkfs.btrfs to add hot data relocation option (-h) which
> > preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
> > BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot data
> > relocation code.  Also added a userspace function to detect whether a
> > block device is an SSD by reading the sysfs block queue rotational flag.
> 
> IMHO this policy is too inflexible. What if I have large array of slow SATA 
> disks and some fast SAS ones ?

  I'm hoping that this is just first cut, and future versions will have options.
For now, it is totally unusable without a way of using mirrored SSD for
hot data.
  Ideally, hot storage devices should be online selectable and changeable.

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

