Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab0DMIAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:00:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab0DMIAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:00:33 -0400
Message-ID: <4BC42475.8080605@cn.fujitsu.com>
Date: Tue, 13 Apr 2010 15:59:49 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
CC: Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 V3] [RESEND] io-controller: add per device weight rule
 support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patchset adds a new interface "weight_device" for blkio controller,
and has already rebased to block tree for-2.6.35 branch.

Thanks,
Gui

