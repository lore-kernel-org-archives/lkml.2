Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0JYAGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:06:04 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:37575 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996Ab0JYAGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:06:03 -0400
Message-ID: <4CC4C8D4.7000502@lougher.demon.co.uk>
Date: Mon, 25 Oct 2010 01:01:24 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] Squashfs: a couple of sparse fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches fix a couple of sparse warnings in Squashfs...

	Squashfs: fix use of __le64 annotated variable
	Squashfs: fix function prototype

Thanks

Phillip
