Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0H0K5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:57:11 -0400
Received: from mail.redflag-linux.com ([219.237.229.196]:47046 "EHLO
	mail.redflag-linux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0H0K5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:57:09 -0400
Message-ID: <4C7799FA.5050403@redflag-linux.com>
Date: Fri, 27 Aug 2010 18:56:58 +0800
From: =?UTF-8?B?Iua9mOWNq+W5syhQZXRlciBQYW4pIg==?= 
	<wppan@redflag-linux.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100324 RedFlag/3.0.1-1rf2.dt8 Thunderbird/3.0.1
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/28] daily commit
References: <1282894186-29199-1-git-send-email-wppan@redflag-linux.com>
In-Reply-To: <1282894186-29199-1-git-send-email-wppan@redflag-linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年08月27日 15:29, Peter Pan(潘卫平) wrote:
> From: Peter Pan<wppan@redflag-linux.com>
>
> Signed-off-by: Peter Pan<wppan@redflag-linux.com>
> ---
>   include/linux/fs.h |    7 ++++---
>   1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 44f35ae..8382a33 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1335,7 +1335,7 @@ struct super_block {
>   	struct mutex		s_lock;
>   	int			s_count;
>   	int			s_need_sync;
> -	atomic_t		s_active;
> +	atomic_t		s_active; // æ´»åŠ¨å¼•ç”¨è®¡æ•°
>   #ifdef CONFIG_SECURITY
>   	void                    *s_security;
>   #endif
> @@ -1343,7 +1343,7 @@ struct super_block {
>
>   	struct list_head	s_inodes;	/* all inodes */
>   	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
> -	struct list_head	s_files;
> +	struct list_head	s_files; // ????????è¢«åˆ†åŒºçš„æ–‡ä»¶é“¾è¡¨????????
>   	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
>   	struct list_head	s_dentry_lru;	/* unused dentry lru */
>   	int			s_nr_dentry_unused;	/* # of dentry on lru */
> @@ -1358,7 +1358,8 @@ struct super_block {
>   	wait_queue_head_t	s_wait_unfrozen;
>
>   	char s_id[32];				/* Informational name */
> -
> +	
> +	// æŒ‡å‘å…·ä½“çš„æ–‡ä»¶ç³»ç»Ÿã€‚å¦‚ext2æŒ‡å‘ext2_sb_infoï¼ˆå³å†…å­˜ä¸­çš„ext2_super_blockï¼‰
>   	void 			*s_fs_info;	/* Filesystem private info */
>   	fmode_t			s_mode;
>

?????????????
-- 
潘卫平
Peter Pan
Red Flag Software Co.,Ltd
