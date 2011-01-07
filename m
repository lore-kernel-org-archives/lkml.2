Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1AGBgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:36:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1AGBgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:36:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IEYYbYvGtlSclX8J5jikdGX9KOdD+8FL1aYjtIPK1SiShx/LOZsuT7H+319l28P3MQ
         Fe+f+vZUNMLkwg5/nPsOmf7nGEfIeMj7abGvgfTED8uiEUxbAjfQ0n5rhJSBWXZMFwKW
         mbLh2EXw9YNNtH75TmmYesJiK/BK/QIEfW6Xs=
MIME-Version: 1.0
In-Reply-To: <1294363682-sup-7971@think>
References: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com> <1294363682-sup-7971@think>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Fri, 7 Jan 2011 09:36:20 +0800
Message-ID: <AANLkTimrZRG1nd+8m28VH+3GD_g3fWAULTuUqL3K+y1X@mail.gmail.com>
Subject: Re: 2.6.37: Bug on btrfs while umount
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> [50010.838804] ------------[ cut here ]------------
>> [50010.838931] kernel BUG at fs/btrfs/inode.c:1616!
>> [50010.839053] invalid opcode: 0000 [#1] PREEMPT SMP
>> [50010.839185] last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
>> [50010.839307] CPU 0
>> [50010.839313] Modules linked in: ipt_addrtype btrfs k10temp
>> [50010.839541]
>> [50010.839653] Pid: 1681, comm: btrfs-endio-wri Not tainted 2.6.37 #1
>
> Could you please pull from the master branch of the btrfs unstable tree.
> We had a late fix that is related to this.
>
Thanks, trying..
