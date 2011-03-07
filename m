Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab1CGGg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:36:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57975 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:36:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jyVYP0U1C9hSZOWH6PNwO+/vIBWxShf3Of8MlcgWaABUDl1ctSGSe6TOEVNd+zPZba
         ni5Pejse5xh07/FoTQTtlVOPT7ESQYjyEzOV2RwOawtnoARMZ/DF7RE3qPUxhJLKBLp9
         CteAjU1Zqasn9s5KZQz0mBpKTzpI+e9fKKGIY=
Date: Mon, 7 Mar 2011 07:36:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-ID: <20110307063618.GA10365@mtj.dyndns.org>
References: <20110307131958.84a5d818.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307131958.84a5d818.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen, Jens.

On Mon, Mar 07, 2011 at 01:19:58PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the block tree got a conflict in
> block/blk-flush.c between commit 255bb490c8c27eed484d538efe6ef6a7473bd3f6
> ("block: blk-flush shouldn't call directly into q->request_fn()
> __blk_run_queue()") from the  tree and commit
> ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae ("block: reimplement FLUSH/FUA
> to support merge") from the block tree.
> 
> The latter rewrote a large part of the file, so I just used that.  If
> this is not correct, please fix it up in the block tree.

I sent Jens a merge commit which should fix this yesterday.

 http://thread.gmane.org/gmane.linux.kernel/1101766/focus=1108915

So, the merge problem should go away soonish.

Thank you.

-- 
tejun
