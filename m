Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1K2GBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:01:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61843 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K2GBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:01:41 -0500
Date: Tue, 29 Nov 2011 00:01:35 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andy Whitcroft <apw@canonical.com>, Chris Mason <chris.mason@oracle.com>,
        Josef Bacik <josef@redhat.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Ivan Vilata i Balaguer <ivan@selidor.net>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices V2
Message-ID: <20111129060135.GC31312@elie.hsd1.il.comcast.net>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
 <20111128121041.GA19498@elie.hsd1.il.comcast.net>
 <20111128122416.GA25996@localhost>
 <4ED434A9.8020809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED434A9.8020809@cn.fujitsu.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:

> This patch has the same problem with your previous one, that it will set
> f_bavail to 0. I've sent out a new patch yesterday.

Thanks for the quick feedback.  That makes sense.  (The new patch
is at [1], for reference.)

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/14584
