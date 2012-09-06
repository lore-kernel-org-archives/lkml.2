Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2IFNf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:35:57 -0400
Received: from mail.tpi.com ([70.99.223.143]:4262 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab2IFNfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:35:55 -0400
Message-ID: <5048A6B6.40307@canonical.com>
Date: Thu, 06 Sep 2012 07:35:50 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: airlied@gmail.com
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave - I couldn't find this patch in your git repo at
git://people.freedesktop.org/~airlied/linux in the drm-next or drm-fixes
branches.

https://patchwork.kernel.org/patch/1379071/

It appears to fix a real problem for Mac users -
http://bugs.launchpad.net/bugs/1039157. See
https://bugs.launchpad.net/ubuntu/oneiric/+source/linux/+bug/1039157/comments/31
for confirmation.

I think it should also be 'Cc: stable@vger.kernel.org'. It applies as
far back as 2.6.32 with minor context differences.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
