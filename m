Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab1IORsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:48:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40396 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934182Ab1IORsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:48:43 -0400
MIME-Version: 1.0
From: Roland Dreier <roland@purestorage.com>
Date: Thu, 15 Sep 2011 10:48:22 -0700
X-Google-Sender-Auth: ZOFndyfp9zsPaoLaAEvxxofeBo0
Message-ID: <CAG4TOxPoz3W1fv50s7+cq_vd6jxbh2=x7bpzvmHRwvW+Nz=EQg@mail.gmail.com>
Subject: Temporary location for infiniband.git tree
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the crowd, I've created a tree at

    https://github.com/rolandd/infiniband

to keep my work for 3.2.  (and I expect to start merging stuff for 3.2 shortly)

Stephen, there is a for-next branch there that you can use instead of the
old kernel.org infiniband.git location for now (it currently should have
nothing not in Linus's tree).

 - Roland
