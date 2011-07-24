Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1GXNIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 09:08:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37386 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1GXNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 09:08:47 -0400
MIME-Version: 1.0
Date: Sun, 24 Jul 2011 22:08:45 +0900
Message-ID: <CAKYAXd-Tg7hXy3zHRtXotDq3wYV8f=v3Py65xn5ccg6KU2gXbw@mail.gmail.com>
Subject: FAT : FAT16 support maximum 4GB file/vol size like WinXP or 7.
From: NamJae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hirofumi

Win NT/XP/7 increased the maximum cluster size to 64KB, and file/vol
size increased 4GB also.

Although increasing , the file size of  linux FAT is still limited at 2GB.

I found that it is limited by sb->s_maxbytes(0x7fffffff) when
partition is formatted by FAT16.

I think that sb->s_maxbytes in fill_super should be set to 0xffffffff
like Fat32.

I want to know your opinion.

Thanks.
