Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab0GGUSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:18:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab0GGUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:18:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/7] block: BKL removal, version 4
Date: Wed, 7 Jul 2010 22:18:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <4C34D74A.4060308@kernel.dk>
In-Reply-To: <4C34D74A.4060308@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007072218.24013.arnd@arndb.de>
X-Provags-ID: V02:K0:fvT2oQ5GFlSs35OmWkkZREDhpZVkckFkJ1fKjjs4kdF
 kpYCSBp7FFsIHyVsO0qajIEj923NIkT0nB3XXd+kYGSWOoN/oo
 OIE80XEHg2Xv5xcbGk0JoKzLK/HZ8QlO6bEWu3vZNz9amBbXkk
 rUfnYGSfIpVlpZWMbRQcEqEX7heS9dHtl0ZJ8it2vCT/+xeKx1
 9YneUfP6Yy35pTsbrbk2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 July 2010 21:36:42 Jens Axboe wrote:
> I'll go over each one tomorrow and add the series.

Ok, thanks!

If it makes your life easier, feel free to get this series from

git pull git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git block

	Arnd
