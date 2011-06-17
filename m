Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab1FQMkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 08:40:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61806 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1FQMke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 08:40:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/5] VFS: Do (nearly) lockless generic_file_llseek
Date: Fri, 17 Jun 2011 14:40:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171440.14224.arnd@arndb.de>
X-Provags-ID: V02:K0:ficGNllrxeVJDnSS0I6DKKioPhV9czcygdfUHLqTmRb
 m+e06T3J+vZL5GRVpWG/OOdHtYidUmvONQ8Luqs9/EByWK0kn/
 zJSazSladnkBPimt4dH1YNZfuJ1QiYvCo1a+aS1w/wK8nrwfEy
 mLcul0SRqugj8Zc96aGp8IJhlihdL0Ll7aqKxGkXtzJTSEZo9u
 8CEXsCWjayfHMH0JVlqCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 23:07:18 Andi Kleen wrote:
> So still need a lock, but can use a cheap local one.
> 
> This patch implements this new scheme in generic_file_llseek.
> I dropped generic_file_llseek_unlocked and changed all callers.

What about default_llseek? If you change generic_file_llseek, you should
probably change that, too.

	Arnd
