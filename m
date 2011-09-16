Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1IPPuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 11:50:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51609
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab1IPPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 11:50:45 -0400
Date: Fri, 16 Sep 2011 11:50:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] VFS: Add generic_file_llseek_size
Message-ID: <20110916155042.GB27150@infradead.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <1316128013-21980-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316128013-21980-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 04:06:50PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a generic_file_llseek variant to the VFS that allows passing in
> the maximum file size of the file system, instead of always
> using maxbytes from the superblock.
> 
> This can be used to eliminate some cut'n'paste seek code in ext4.

I'd reorder this to the front of the series.  Also I think this
helper could be used to implement default_llseek.

