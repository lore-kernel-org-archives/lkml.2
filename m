Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032584Ab2CPHfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:35:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60997 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161301Ab2CPHfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:35:24 -0400
Message-Id: <20120316073213.656519005@fusionio.com>
User-Agent: quilt/0.48-1
Date: Fri, 16 Mar 2012 15:32:13 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com,
        martin.petersen@oracle.com
Subject: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches add TRIM support for raid linear/0/1/10. I'll add TRIM support for
raid 4/5/6 later. The implementation is pretty straightforward and
self-explained.

v1->v2:
1. fixed a checking issue
2. dropped discard request plug and replace it with no discard merege, because
current SCSI layer can't handle discard request merge.

Thanks,
Shaohua
