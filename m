Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0KHXTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:19:03 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18955 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0KHXTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:19:02 -0500
Date: Tue, 9 Nov 2010 00:07:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/17][trivial] Remove unnecessary casts of void ptr returning
 alloc function return values
Message-ID: <alpine.LNX.2.00.1011082243220.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which 
it's completely unnecessary/pointless to cast to other pointer types since 
that happens implicitly.
So, I decided to clean out the remaining such casts that we have in the 
kernel. I almost wish I'd never done so since that task took me into 
staging/ and past files that made my eyes hurt and made me wish I'd been 
born blind without a screenreader and never having learned braille 
(specific filenames excluded to protect the guilty). But, since I was not 
on a general cleanup mission but only wanted to remove those unnecessary 
casts, I managed to escape with partial eyesight intact.

Anyway, this series removes all remaining unnecessary casts of void 
pointers returned from [vk][cmz]alloc(_node)() that I could find. 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

