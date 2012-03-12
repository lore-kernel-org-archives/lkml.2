Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2CLDNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:13:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61279 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2CLDNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:13:14 -0400
Message-Id: <20120312030412.375458948@fusionio.com>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 11:04:12 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
Subject: [patch 0/7] Add TRIM support for raid linear/0/1/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches add TRIM support for raid linear/0/1/10. I'll add TRIM support for
raid 4/5/6 later. The implementation is pretty straightforward and
self-explained.

Thanks,
Shaohua
