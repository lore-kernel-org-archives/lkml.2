Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0FZLLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:11:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46808 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0FZLLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FtsTovWCpnVHrw8ogCALvp4RpULZ0WBFf4QVUIBXMKo5DAcPflvvLyQjErZFRZwWlK
         y+iYKXK5yJhEhAVv6bMeZMTjyl/GYr2uZuxOhVnIq1+MP+0aHllfROovyCx0xgHbXE2S
         khz8seZ8se7HG4Q3zgggY1FSpuSM3ugHqYgOw=
From: Christoph Mair <christoph.mair@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Datta Shubhrajyoti <shubhrajyoti@ti.com>
Subject: bmp085: add inline and ABI documentation 
Date: Sat, 26 Jun 2010 13:10:22 +0200
Message-Id: <1277550624-13879-1-git-send-email-christoph.mair@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100621144958.d5fc694e.akpm@linux-foundation.org>
References: <20100621144958.d5fc694e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches document the userspace interface of the bmp086 driver.
The first patch adds a file to Documentation/ABI/testing which describes the sysfs files created by the driver.
The second patch adds some more documentation to the comment header of the driver code itself. It also includes a link to the datasheet.

