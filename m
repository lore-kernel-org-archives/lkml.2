Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1GZJmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:42:15 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49016
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab1GZJmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:42:10 -0400
Date: Tue, 26 Jul 2011 05:42:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vfs: dont chain pipe/anon/socket on superblock s_inodes
 list
Message-ID: <20110726094204.GA12086@infradead.org>
References: <20110721204042.GB31405@ZenIV.linux.org.uk>
 <1311294452.2576.18.camel@schen9-DESK>
 <20110723132411.GA22183@infradead.org>
 <1311633550.2576.33.camel@schen9-DESK>
 <20110725225154.GD22133@ZenIV.linux.org.uk>
 <1311636178.2576.34.camel@schen9-DESK>
 <1311660013.2996.6.camel@edumazet-laptop>
 <1311668466.2355.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110726090357.GA13013@infradead.org>
 <1311672994.2355.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311672994.2355.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:36:34AM +0200, Eric Dumazet wrote:
> [PATCH v2] vfs: dont chain pipe/anon/socket on superblock s_inodes list
> 
> Workloads using pipes and sockets hit inode_sb_list_lock contention.
> 
> superblock s_inodes list is needed for quota, dirty, pagecache and
> fsnotify management. pipe/anon/socket fs are clearly not candidates for
> these.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

