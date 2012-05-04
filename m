Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2EDUse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:48:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57344 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab2EDUsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:48:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
Date: Fri, 4 May 2012 20:48:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <20120503212151.568.91854.stgit@bob.linux.org.uk> <20120503212219.568.15653.stgit@bob.linux.org.uk>
In-Reply-To: <20120503212219.568.15653.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042048.21771.arnd@arndb.de>
X-Provags-ID: V02:K0:oXUH9b6p6XC+Tgq4egKbnDXU86niZG5WmtsKdpbdxir
 2/cb/ikm+enR0CTIgAocIB9eXiGNnP36aYGC2Zabb2L/mWsFwn
 Iv6/ZxYWLYYi8oTsfluRyTXUogo0FrNJc6Exd6znz7WoBoOZPq
 Fg/CiczA2a7PzbbKIi6Tir8Q90vl4jaHcBRF2fI0+VSiZnwBgw
 OlkvZShvEHFXsL8C3kK8ZBHFBVhiynFg4ne74NOG03ONTOjX2O
 R0yKsYN/reapQfbEAME0SvLuHpsPUYVx8dNENtX09MEsOAaBuD
 KjVPvcxYZpWRyiZh+ctT/kXLS9xbmfWR+PwXKJe5Qe/ovIXfZD
 AvrCBW71fOyw+AHSuTAQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Alan Cox wrote:
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> In each remaining case the tty_lock is associated with a specific tty. This
> means we can now lock on a per tty basis. We do need tty_lock_pair() for
> the pty case. Uglier but still a step in the right direction.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
