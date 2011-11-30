Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab1K3Pk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:40:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab1K3Pkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:40:55 -0500
Date: Wed, 30 Nov 2011 15:40:46 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Josef Bacik <josef@redhat.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Ivan Vilata i Balaguer <ivan@selidor.net>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices V2
Message-ID: <20111130154046.GG6165@shadowen.org>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
 <20111128121041.GA19498@elie.hsd1.il.comcast.net>
 <20111128122416.GA25996@localhost>
 <4ED434A9.8020809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED434A9.8020809@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:26:01AM +0800, Li Zefan wrote:

> This patch has the same problem with your previous one, that it will set
> f_bavail to 0. I've sent out a new patch yesterday.

Ahh, sounds great thanks.  Often a patch is a good way to start a
discussion to a more correct patch.  Specially when one is not an expert
in the area.

-apw
