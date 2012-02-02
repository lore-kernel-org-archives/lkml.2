Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2BBBP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:15:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57128 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2BBBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:15:55 -0500
MIME-Version: 1.0
In-Reply-To: <1328144756.2768.57.camel@dabdike.int.hansenpartnership.com>
References: <20120121082857.GC32134@elte.hu> <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
 <20120121165830.GA9216@elte.hu> <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
 <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
 <CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
 <CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
 <20120131115855.5861bad7@pyramind.ukuu.org.uk> <20120131120922.GD32010@elte.hu>
 <20120131121820.58a1db97@pyramind.ukuu.org.uk> <20120131122339.GG32010@elte.hu>
 <CA+55aFw4F-02NxbQHmpy0KtXxKc9++HutgVXd7nGe0G7NqG+Gw@mail.gmail.com> <1328144756.2768.57.camel@dabdike.int.hansenpartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 17:15:34 -0800
X-Google-Sender-Auth: Vn9ChX7yYQHZ1X-kxfZeEdz5Tq0
Message-ID: <CA+55aFxCn5vzngrQbA5MZRn+K1uqqQroX+M+MYVuwrToV8vjCg@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
To: James Bottomley <jbottomley@parallels.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 5:05 PM, James Bottomley
<jbottomley@parallels.com> wrote:
>
> And this was about the point I concluded last time that it simply wasn't
> worth it with the number of different possibilities for the primitives

Umm? Two?

Two really doesn't seem like a big number to me.

                    Linus
