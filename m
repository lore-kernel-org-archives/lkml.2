Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab2CUEYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:24:12 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:34961 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2CUEYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=dreamhost.com;
	 b=Cuy9VKrS1UeeNnndBLcLDHItgOjxPOaWB0en4rEU7TVFNWyuU9xx9ncGvNAvG
	jtrIA+e7BAaVBZ+Y3dNK+8Dd0sGUo126sYGOLD4Gi/pJTDRnyjonklaqvUGJqvSZ
	tZn+tz63Qq1LxZDIvSLsEsHNK6YIjLPCD0Iurt64pJwK6c=
Message-ID: <4F6957EB.5030309@dreamhost.com>
Date: Tue, 20 Mar 2012 23:24:11 -0500
From: Alex Elder <elder@dreamhost.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Sage Weil <sage@newdream.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Durgin <josh.durgin@dreamhost.com>
Subject: Re: linux-next: build failure after merge of the ceph tree
References: <20120321124007.e879c834619c7bb9298d5694@canb.auug.org.au>
In-Reply-To: <20120321124007.e879c834619c7bb9298d5694@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 08:40 PM, Stephen Rothwell wrote:
> Hi Sage,
>
> After merging the ceph tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/block/rbd.c: In function 'rbd_add':
> drivers/block/rbd.c:2384:2: error: 'struct rbd_image_header' has no member named 'snap_rwsem'
>
> Caused by commit dd2a081fb58f ("rbd: move snap_rwsem to the device,
> rename to header_rwsem") interacting with commit 0e805a1d8577 ("rbd:
> initialize snap_rwsem in rbd_add()") from Linus' tree.
>
> I used the ceph tree from next-20120320 for today.

I'll take a look at this tomorrow.  I'm sorry my earlier
suggestion didn't address this.

					-Alex
