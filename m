Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2JUGCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 02:02:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2JUGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 02:02:48 -0400
Message-ID: <50839002.8020305@gmail.com>
Date: Sun, 21 Oct 2012 14:02:42 +0800
From: caiyuqing <yuqingcaik@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: question about context switch on arm Linux
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, all.
I have some questions about context switch on arm Linux (my target is
ARMv7-a).
1. Does arm linux support FCSE to handle the context switch?
2. If using FCSE, that means the processes number limit is 128 and the
memory limit is 32MB per process, is that right?

Thanks
qing

