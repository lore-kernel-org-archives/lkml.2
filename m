Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab2A1Ndh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 08:33:37 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59934 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2A1Ndg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 08:33:36 -0500
Message-ID: <1327757611.7199.6.camel@edumazet-laptop>
Subject: Re: Bad SSD performance with recent kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Date: Sat, 28 Jan 2012 14:33:31 +0100
In-Reply-To: <20120128125108.GA9661@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
	 <20120128125108.GA9661@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 28 janvier 2012 à 20:51 +0800, Wu Fengguang a écrit :

> Would you please create a filesystem and large file on sda and run the
> tests on the file? There was some performance bug on reading the raw
> /dev/sda device file..

Hmm... latest kernel has the performance bug right now.

Really if /dev/sda is slow, we are stuck.

FYI, I started a bisection.



