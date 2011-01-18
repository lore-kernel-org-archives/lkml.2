Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1ARVVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1ARVVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:21:06 -0500
Date: Tue, 18 Jan 2011 16:20:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 2/6 v3] cfq-iosched: Introduce cfq_entity for CFQ group
Message-ID: <20110118212056.GK27946@redhat.com>
References: <4D180ECE.4000305@cn.fujitsu.com>
 <4D18536B.9090109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D18536B.9090109@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 04:50:51PM +0800, Gui Jianfeng wrote:

[..]
> -static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
> +static struct cfq_entity *cfq_rb_first_entity(struct cfq_rb_root *root)
>  {
>  	if (!root->left)
>  		root->left = rb_first(&root->rb);
>  
>  	if (root->left)
> -		return rb_entry_cfqg(root->left);
> +		return rb_entry_entity(root->left);
>  

Why are we defining cfq_rb_first_entity(). Can't we simply use cfq_rb_first()
as introduced in first patch.

Thanks
Vivek
