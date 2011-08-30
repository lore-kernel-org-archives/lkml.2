Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1H3KpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:45:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34127 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1H3KpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:45:08 -0400
Subject: Question with "container_of(ptr, type, member)"
From: peter <lifulong2c2i2c@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 18:44:59 +0800
Message-ID: <1314701099.1728.6.camel@peter-2ci2c>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about the macro " container_of(ptr, type, member) "
I can write it as this,
 #define container_of(ptr, type, member) ({ \
	(type *) ((char *) ptr - offset_of(type, member)); \
	})
It can act the same as 
#define container_of(ptr, type, member) ({            \
	 const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
	 (type *)( (char *)__mptr - offsetof(type,member) );})
So why we don't use the first one ?
Thanks for your answer.
(I am a kernel newbie ,and sorry for my poor english~)


