Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776Ab0J0BBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:01:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50692 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760748Ab0J0BBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=Z6H+BHv3+LyojoL1z0qqnM2Ql6QoYIPIZFrF9GJrtNI+FRLG5BlrTP0Aar196wvlxP
         uYhCP187MxBCZOFaFGJQzObUu/VRLRCYqD4xWJt2pcm6NxZJKmvbbKQT7ccJFU55bvWx
         qnxYSsP6Hgo9FAX/fdYym/D7s9sdvhYz2VntA=
References: <cover.1288059486.git.joe@perches.com> <20101026155028.GA13097@core.coreip.homeip.net> <1288135531.4145.59.camel@Joe-Laptop> <201010261740.13566.dmitry.torokhov@gmail.com> <1288140416.4145.76.camel@Joe-Laptop>
In-Reply-To: <1288140416.4145.76.camel@Joe-Laptop>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <BFA186FD-32F7-4E1A-9193-CA1575248B73@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8B117)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>, pr_fmt. Fix dbg and __FILE__ use
Date: Tue, 26 Oct 2010 18:00:44 -0700
To: Joe Perches <joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 26, 2010, at 5:46 PM, Joe Perches <joe@perches.com> wrote:

> On Tue, 2010-10-26 at 17:40 -0700, Dmitry Torokhov wrote:
>>> Mind if I move the time to the front like this?
>>> +#define dbg(format, arg...)                                            \
>>> +do {                                    \
>>> +    if (i8042_debug)                        \
>>> +        printk(KERN_DEBUG KBUILD_MODNAME ": [%d]" format),    \
>>> +                      (int)(jiffies - i8042_start_time), ##arg);    \
>>> +} while (0)
>> Another option would be to leave '\n' in dbg() and leave most of the
>> callers as is.
> 
> That's really error prone though.
> 

In what way?

-- 
Dmitry

