Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0KCQy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:54:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52870 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0KCQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ecubf6gggyR19HzNqNWgV5EHf0dx6xlNOvWPGX1XBtLbFIIyzzcn765zJox4HoV9HI
         MvAcgzF+1jmFq8QSGPzd+A3sL5tLOGr+AHf4ltSyUocuNltWLwe5RKXzZAiyiJvknj3A
         7yhkzNW5lMXPo9jijzo1JLDb8UEbzjfwQ6jds=
From: cdhmanning@gmail.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 0/9] Add yaffs2 file system
Date: Thu,  4 Nov 2010 05:53:15 +1300
Message-Id: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Manning <cdhmanning@gmail.com>

Adding yaffs2 file system.

This code is patched from 5409719091c79983abc45bcc3070bce6786c8278 at 
git://www.aleph1.co.uk/yaffs2.

This patch set is likely to be far more palatable than the last one:
* Multi-OS code has been removed.
* Types changed from __u32-->u32 etc.
* typedefs removed.
* Lindenting done.

This code ran various tests for the whole night with no problems seen.

Comments/feedback welcome.

-- Charles
