Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab2B2OOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:14:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658Ab2B2OOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:14:39 -0500
Date: Wed, 29 Feb 2012 15:14:33 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Zhi Li <xiaoxiang.fu@163.com>
Subject: zero devno in /proc/self/mountinfo
Message-ID: <20120229141433.GB8471@x2.net.home>
References: <1330504129-5545-1-git-send-email-lizhi1215@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330504129-5545-1-git-send-email-lizhi1215@gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 04:28:49PM +0800, Zhi Li wrote:
> zhi@debian-lizhi:~$ cat /proc/self/mountinfo
> 14 19 0:0 / /sys rw,nosuid,nodev,noexec,relatime - sysfs none rw

 Strange, I have never seen zero (0:0) devno. Is it correct? Seems
 like a bug.

   Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
