Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab1DRLiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:38:24 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60380 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1DRLiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:38:17 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] Implement /dev/byte (a generic byte source similiar to /dev/zero)
Date: Mon, 18 Apr 2011 13:37:55 +0200
Message-Id: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I don't know if this patch qualifies for inclusion into the mainline kernel, but
maybe someone else would be interested in such, so I'm posting it here.

The main idea for that device was to have a source for 0xff to clear FLASH based
devices. And to make it more generic, I've added the possibility to change the
default value on a per file descriptor basis.

I don't want to discuss if such a device makes sense or if such should be done
in userspace only. I like it as a device, otherwise I wouldn't have written it.
So besides this message, I will not take part in such a discussion.

Regards,

Alexander Holler

