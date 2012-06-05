Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2FEXkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:40:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39662 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2FEXkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <1338939316.11962.3.camel@joe2Laptop>
References: <cover.1338889066.git.joe@perches.com> <20120605142826.d92316a0.akpm@linux-foundation.org>
 <1338934303.5780.8.camel@joe2Laptop> <20120605151754.a794ac7c.akpm@linux-foundation.org>
 <1338936572.5780.29.camel@joe2Laptop> <20120605162910.caccb0d4.akpm@linux-foundation.org>
 <1338939316.11962.3.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 6 Jun 2012 01:39:57 +0200
Message-ID: <CAPXgP13J+8-dPpZkSfh9sM3xXujC2Rb9tJaOvGoEPghgdr8jiw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 1:35 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-06-05 at 16:29 -0700, Andrew Morton wrote:
>> What about writes starting with \001n?  AFACIT, that will be stripped
>> away and the printk level will be altered.  This is new behavior.
>
> Nope.
>
> # echo "\001Hello Andrew" > /dev/kmsg
> /dev/kmsg has
> 12,774,2462339252;\001Hello Andrew

Try "echo -e"? The stuff is copied verbatim otherwise.

Kay
