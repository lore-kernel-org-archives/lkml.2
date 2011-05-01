Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1EATpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 15:45:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58744 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab1EATpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 15:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=AVnQ74up6ASl9+OhACCbvHbCIqwWilz6i4oA3V+xUetjOe/8dY74HFQ5TGyTki87tZ
         THrnBIEJlCqEUqju4eFryjw/LQwVcQIY2MKfjQzu3xc9ZQAQHg2DY8HJQX1lqn5uwShB
         BxtfjVesop9VMHqxTJFed2A51OSSp26x1P3K8=
MIME-Version: 1.0
Date: Sun, 1 May 2011 21:45:10 +0200
Message-ID: <BANLkTinSApKY=y-f=Fpkd4-k=SFT-jJKhA@mail.gmail.com>
Subject: [Regression] Reiserfs deadlock in 2.6.36,2.6.37 and more
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I have a box currently running two parallel loops of git pull.
>It has run for two hours now and nothing happened, I'm going to
>let that wheel run the whole night and see tomorrow.

Someone seed me a private mail that it ran into the very same problem
shortly after upgrading openSuSE 11.3 to 11.4, running
rootfs on ext4, dm-crypted /home with reiserfs and a non-encrypted
reiserfs data-share.

I asked him to send publically this mail here with full details.

Bastien
