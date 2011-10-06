Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab1JFCVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 22:21:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56595 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab1JFCVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 22:21:24 -0400
MIME-Version: 1.0
Date: Thu, 6 Oct 2011 10:21:23 +0800
Message-ID: <CADLM8XP0q0GDyK68rrCb46L97HmTjL0WxY03EzwjTB4buBTeow@mail.gmail.com>
Subject: One comment on fcb11918
From: Wei Yang <weiyang.kernel@gmail.com>
To: bjorn.helgaas@hp.com
Cc: hpa@zytor.com, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn

This is very glad to talk to you.

In your commit fcb11918, you add a line in find_resource().

@@ -394,6 +398,7 @@ static int find_resource(struct resource *root,
struct resource *new,
        struct resource *this = root->child;
        struct resource tmp = *new, avail, alloc;

+       tmp.flags = new->flags;
        tmp.start = root->start;
        /*
         * Skip past an allocated resource that starts at 0, since the
assignment

I am curious about why you want to add this line.

-- 
Wei Yang
Help You, Help Me
