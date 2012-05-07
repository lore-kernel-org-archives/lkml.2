Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2EGLES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab2EGLER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:04:17 -0400
Message-ID: <4FA7AC24.7030700@redhat.com>
Date: Mon, 07 May 2012 08:04:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: drivers: Probable misuses of ||
References: <1333580415.23520.29.camel@joe2Laptop>
In-Reply-To: <1333580415.23520.29.camel@joe2Laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-04-2012 20:00, Joe Perches escreveu:
> Likely these should be && not ||

> drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))

This one is handled by this patch:
	http://git.linuxtv.org/mchehab/media-next.git/commit/3e1fd4783b2b4ae887112e6af3ce1bb1a6be19c4

Regards,
Mauro
