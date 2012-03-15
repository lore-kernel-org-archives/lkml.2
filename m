Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030731Ab2COPBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:01:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52188 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378Ab2COPBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:01:18 -0400
Date: Thu, 15 Mar 2012 16:01:12 +0100
From: Andrea Gelmini <andrea.gelmini@gmail.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: sensille@gmx.net, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs/ulist: replace the magic number 128 with macro
 definition ULIST_SIZE_INCREMENT
Message-ID: <20120315150112.GC6474@pambianco.com>
References: <4F5837B9.6000006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5837B9.6000006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 12:38:17PM +0800, Wang Sheng-Hui wrote:
> Remove the magic number 128 in btrfs/ulist.c.
> Introduce the macro definition ULIST_SIZE_INCREMENT in btrfs/ulist.h.


I'm using this patch without problem since you published it (compressed
/home with hourly snapshot delete/creation).

Thanks a lot for your work,
Andrea
