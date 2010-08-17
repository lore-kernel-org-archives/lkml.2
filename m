Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873Ab0HQS5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:57:13 -0400
Received: from purkki.adurom.net ([80.68.90.206]:55145 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762855Ab0HQS5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:57:12 -0400
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Filesystem corruption with 2.6.36-rc1-wl+ and ecryptfs
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 17 Aug 2010 21:57:10 +0300
Message-ID: <87tymt9iex.fsf@purkki.adurom.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just installed my first 2.6.36 kernel, 2.6.36-rc1-wl+ from
wireless-testing, and immeadialy (during first boot) got major
corruption in the filesystem. For example, gnome lost it's settings,
~/.ssh was empty etc. Now, with an older kernel, my directory
structure has duplicate entries, like this:

$ ls -ald D*
drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Desktop/
drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Desktop/
drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Documents/
drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Documents/
drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Downloads/
drwxr-xr-x 2 kvalo kvalo 4096 2010-08-17 19:21 Downloads/

I'm using ecryptfs and that's my major suspect for the corruption, but
naturally I can't be sure because I'm just guessing here. 

Some info about my system:

Samsung X120 laptop
Ubuntu 10.04
amd64, 2 CPUs
ext4, /home/kvalo encrypted with ecryptfs
ath9k

-- 
Kalle Valo
