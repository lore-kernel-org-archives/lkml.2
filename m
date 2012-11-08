Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2KHFYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 00:24:33 -0500
Received: from mail-pa0-f56.google.com ([209.85.220.56]:45215 "EHLO
	mail-pa0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2KHFYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 00:24:31 -0500
X-Greylist: delayed 4083 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2012 00:24:31 EST
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Wed, 7 Nov 2012 19:42:08 -0800 (PST)
In-Reply-To: <fa.saEZNDPM1prgEluQ9an9kfyj/R0@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=58.61.221.22; posting-account=IMnzsQkAAADhfEsKLqj28hWfPL_aKCuM
NNTP-Posting-Host: 58.61.221.22
References: <fa.saEZNDPM1prgEluQ9an9kfyj/R0@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 58.61.221.22
MIME-Version: 1.0
Message-ID: <d8ae63c6-4bd4-4fbc-94eb-bc33b40dae0f@googlegroups.com>
Subject: Re: crash in rb_insert_color()
From: xrjrunning@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i

在 2008年2月2日星期六UTC+8上午1时27分50秒，Zoltan Menyhart写道：
> I have got a crash on an 8 processor ia64 machine with the kernel 2.6.18.8:
> 
> [<a00000010003cb30>] ia64_fault+0x14b0/0x1600
>                                 sp=e00000019ea5f930 bsp=e00000019ea51408
>     r32 : 000000000000001a r33 : 0000000400000020 r34 : 0000000000000010
>     r35 : 000000000003800f r36 : e00000019ea5fbb8 r37 : e00000019ea5fbb0
>     r38 : a00000010027f2e0 r39 : e00000019ea5f9c0 r40 : 000000000000000b
>     r41 : a00000010000c4e0 r42 : 0000000000000005 r43 : a000000100a90050
>  [<a00000010000c4e0>] ia64_leave_kernel+0x0/0x280
>                                 sp=e00000019ea5fb60 bsp=e00000019ea51408
>  [<a00000010027f2e0>] rb_insert_color+0x60/0x380
>                                 sp=e00000019ea5fd30 bsp=e00000019ea513b8
>     r32 : e0000004acb19448 r33 : e00000052a7ba100 r34 : e0000002799a5908
>     r35 : 0000000000000000 r36 : a0000002046f7810 r37 : 0000000000000690
>     r38 : 6f732e7365725f73 r39 : e0000004acb1c708 r40 : e00000052a7ba100
>  [<a0000002046f7810>] ext3_htree_store_dirent+0x270/0x2e0 [ext3]
>                                 sp=e00000019ea5fd30 bsp=e00000019ea51350
>     r32 : e00000052a7ba100 r33 : 0000000059bf4f42 r34 : 0000000026f5c228
>     r35 : e00000082bb9063c r36 : e0000004acb19440 r37 : e0000002799a5918
>     r38 : 000000000000003d r39 : e00000082bb90642 r40 : e0000004acb19444
>     r41 : e0000002799a5908 r42 : a000000204708a70 r43 : 0000000000000611
>     r44 : a000000204716448
>  [<a000000204708a70>] htree_dirblock_to_tree+0x1b0/0x280 [ext3]
>                                 sp=e00000019ea5fd30 bsp=e00000019ea512f0
>     r32 : e000000126191780 r33 : e00000082bb907f8 r34 : e00000082bb9063c
>     r35 : e00000019ea5fd50 r36 : 0000000000000000 r37 : 0000000000000000
>     r38 : e00000014ff15b68 r39 : 0000000000000018 r40 : e00000019ea5fd54
>     r41 : a000000204708c40 r42 : 0000000000000795 r43 : a000000204716448
>  [<a000000204708c40>] ext3_htree_fill_tree+0x100/0x460 [ext3]
>                                 sp=e00000019ea5fd40 bsp=e00000019ea51278
>     r32 : e000000126191780 r33 : 0000000000000000 r34 : 0000000000000000
>     r35 : e00000052a7ba128 r36 : a0000002046f82b0 r37 : e00000014ff060b8
>     r38 : 0000000000000000 r39 : 00000000000000d0 r40 : 60000000000101cc
>     r41 : 600ffffffa5ff5b0 r42 : 600ffffffa5ff618 r43 : 000000000000f000
>     r44 : a0000002046f82f0 r45 : 0000000000000fa6 r46 : a000000204716448
>  [<a0000002046f82f0>] ext3_readdir+0x890/0xcc0 [ext3]
>                                 sp=e00000019ea5fda0 bsp=e00000019ea51178
>     r32 : e000000126191780 r33 : e00000019ea5fe20 r34 : a000000100656570
>     r35 : e00000052a7ba108 r36 : e00000052a7ba100 r37 : e00000052a7ba124
>     r38 : e00000052a7ba120 r39 : e00000014ff06160 r40 : e000000126191830
>     r41 : e0000001261917b8 r42 : e00000052a7ba128 r43 : e000000126191790
>     r44 : e00000052a7ba118 r45 : e00000014ff060b8 r46 : e00000052a7ba124
>     r47 : e00000087a0b5980 r48 : e00000087a0b59a0 r49 : e00000052a7ba108
>     r50 : 0000000000000000 r51 : 0000000000000000 r52 : 0000000000000000
>     r53 : 0000000000000793 r54 : e00000019ea5fe00 r55 : 0000000000000001
>     r56 : 0000000000000793 r57 : 0000000000000000 r58 : 200000000003cc7c
>     r59 : a00000010017bd60 r60 : 000000000000058e r61 : a000000204716448
>     r62 : 000000001555a559
>  [<a00000010017bd60>] vfs_readdir+0x1a0/0x200
>                                 sp=e00000019ea5fe10 bsp=e00000019ea51120
>     r32 : e000000126191780 r33 : a000000100656570 r34 : e00000019ea5fe20
>     r35 : fffffffffffffffe r36 : e0000001261917a0 r37 : e00000014ff060b8
>     r38 : e000000126191790 r39 : e00000014ff06178 r40 : a00000010017c540
>     r41 : 0000000000000915 r42 : a000000100a90050
> 
> Here is the beginning of rb_insert_color():
> 
> void rb_insert_color(struct rb_node *node, struct rb_root *root)
> {
>         struct rb_node *parent, *gparent;
> 
>         while ((parent = rb_parent(node)) && rb_is_red(parent)) {
>                 gparent = rb_parent(parent);
>                 if (parent == gparent->rb_left) {
> 
> When it crashes, I've got the following nodes:
> 
> p/x *((struct rb_node *) 0xe0000004acb19448)    // node
> {
>   rb_parent_color = 0xe0000002799a5908,
>   rb_right = 0x0,
>   rb_left = 0x0
> }
> p/x *((struct rb_node *) 0xe0000002799a5908)    // parent = rb_parent(node)
> {
>   rb_parent_color = 0x0,
>   rb_right = 0x0,
>   rb_left = 0xa000000100650000			// seems to be valid
> }
> 
> Note that "node" is not necessarily the same as the argument of
> rb_insert_color() was.
> 
> gparent = rb_parent(parent) is NULL, and the kernel obviously traps
> at if (parent == gparent->rb_left).
> 
> Does the algorithm guarantee that if a node is red, it must have a parent?
> I guess yes.
> (I have not seen any modification in rb_insert_color() since my 2.6.18.8.)
> 
> Is mutex_lock(&inode->i_mutex) in vfs_readdir() enough to protect the tree?
> I guess yes.
> 
> I have got no idea how it can happen.
> Has something been corrected since?
> 
> Regards,
> 
> Zoltan Menyhart
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

i got similar problem,have you found the reason?
