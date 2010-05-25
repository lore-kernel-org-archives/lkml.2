Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0EYOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:09:59 -0400
Received: from thunk.org ([69.25.196.29]:45993 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab0EYOJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:09:57 -0400
Date: Tue, 25 May 2010 10:09:54 -0400
From: tytso@mit.edu
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Add a missing trace hook
Message-ID: <20100525140954.GI5556@thunk.org>
Mail-Followup-To: tytso@mit.edu, Li Zefan <lizf@cn.fujitsu.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <4BFA37FC.1000709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFA37FC.1000709@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 04:25:32PM +0800, Li Zefan wrote:
> Commit f8ec9d6837241865cf99bed97bb99f4399fd5a03 added a
> trace event ext4_da_release_space, but didn't add some
> corresponding trace hook.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks for pointing this out, added to the ext4 tree.

       	   	    	      	       - Ted
