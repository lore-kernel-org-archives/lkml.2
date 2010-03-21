Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0CUBcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 21:32:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38797 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0CUBcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 21:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=eBdpsi9ZaJLePu+yfLk9Ql3RR6omqihrWPRAeooD7EaMOIR/Hc4kHHGo7D6NFTS9ox
         xrhhnPWssATWu+SqeZMHj98boYsi6Qrv3JaHOPORor6s0hKi711hYakzxsEnt+EX/Pd4
         tk+L1mV108pVjwi79FxHdO29Wr9F70ph5KhOg=
Subject: how the mmap() work for scatter_sg memory?
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Mar 2010 09:32:04 +0800
Message-ID: <1269135124.2517.6.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

i see the drm kernel source code, for SCATTER MEMORY, it use
vmalloc_32() to alloce some pages, and put them into sglist table in
drm_scatter.c. and in drm_mmap_locked(), why it not call
remap_vmalloc_range() to remap the pages to vm_area for mmap? how it
remap pages(that memory using vmalloc_32() to alloc) to vm_area? 
for consistany memory, it often call remap_pfn_range() for remap.
so i am puzzle how the mmap() is work for sg? would someone give it more
details? Thanks.

Best
Figo

