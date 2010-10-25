Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0JYLaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:30:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab0JYLaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:30:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] hfsplus: fix double lock typo in ioctl
Date: Mon, 25 Oct 2010 12:55:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@tuxera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20101025045326.GW5985@bicker>
In-Reply-To: <20101025045326.GW5985@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010251255.24670.arnd@arndb.de>
X-Provags-ID: V02:K0:/9QSnNIvQ0tOQI0yXwl7cZKYmuECNcgPgWwPpiatE1L
 1N0JROF6e3EMvY5Riel+oB6jrWWMVHLPpo41ITQ3sCZ4wTxJSJ
 pyF8kRCJvnX4/8xECImRmWZSY9P0jKYLq2WIh/ZQdJiVw6BvGj
 gY0zCuvYocskmm+b4Se8k7/hWdwKS/XaaE+I4ly87sI7OS6Hz2
 gFrrL5GqiXT22PfXVs/IA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 October 2010, Dan Carpenter wrote:
> This was supposed to be a mutex_unlock() instead of a mutex_lock().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

