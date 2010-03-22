Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0CVPnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:43:50 -0400
Received: from mail.perches.com ([173.55.12.10]:1031 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0CVPns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:43:48 -0400
Subject: Re: [patch v2] cx231xx: card->driver "Conexant cx231xx Audio" too
 long
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Srinivasa Deevi <srinivasa.deevi@conexant.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <20100322153909.GC23411@bicker>
References: <20100319114957.GQ5331@bicker> <s5hr5ncxvm9.wl%tiwai@suse.de>
	 <20100322153909.GC23411@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 08:43:47 -0700
Message-ID: <1269272627.22616.35.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 18:39 +0300, Dan Carpenter wrote:
> card->driver is 15 characters and a NULL, the original code could 
> cause a buffer overflow.

> In version 2, I used a better name that Takashi Iwai suggested.

Perhaps it's better to use strncpy as well.


