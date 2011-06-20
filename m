Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1FTAhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 20:37:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:38534 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab1FTAhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 20:37:33 -0400
Date: Mon, 20 Jun 2011 10:37:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Forbes <chrisf@ijw.co.nz>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: inode: fixed coding style issue
In-Reply-To: <1308295341-27566-1-git-send-email-chrisf@ijw.co.nz>
Message-ID: <alpine.LRH.2.00.1106201036040.5170@tundra.namei.org>
References: <1308295341-27566-1-git-send-email-chrisf@ijw.co.nz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Chris Forbes wrote:

> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -75,7 +75,8 @@ static struct inode *get_inode(struct super_block *sb, int mode, dev_t dev)
>  			inode->i_op = &simple_dir_inode_operations;
>  			inode->i_fop = &simple_dir_operations;
>  
> -			/* directory inodes start off with i_nlink == 2 (for "." entry) */
> +			/* directory inodes start off with i_nlink == 2
> +			 * (for "." entry) */

This is not correct for multi-line comments.

> -	static struct tree_descr files[] = {{""}};
> +	static struct tree_descr files[] = { {""} };

Why ?



-- 
James Morris
<jmorris@namei.org>
