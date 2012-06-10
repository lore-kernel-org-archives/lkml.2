Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2FJJTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:19:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50875 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2FJJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:19:35 -0400
Message-ID: <4FD46521.5070900@gmail.com>
Date: Sun, 10 Jun 2012 11:13:05 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after the merge of pramfs in the LTSI kernel and after the "hot topic" 
NVM Mapping API, here a new submission of pramfs code. Even if the code 
won't be in mainline the review is really useful to me, so any comment 
is welcome.

The patch series is based on 3.5-rc2.

Pramfs documentation:

http://pramfs.sourceforge.net

Git repo:

git://pramfs.git.sourceforge.net/gitroot/pramfs/pramfs

Marco
