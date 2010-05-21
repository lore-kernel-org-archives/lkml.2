Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0EUImp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:42:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57590 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab0EUImn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:42:43 -0400
Message-ID: <4BF64712.1070500@cn.fujitsu.com>
Date: Fri, 21 May 2010 16:40:50 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] io-controller: Add new interfaces to trace backlogged
 group status
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series implements three new interfaces to keep track of tranferred bytes,
elapsing time and io rate since group getting backlogged. If the group dequeues
from service tree, these three interfaces will reset and shows zero.

Thanks
Gui
