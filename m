Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0JCL6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 07:58:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44253 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0JCL6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 07:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <20101003112920.GB32736@n2100.arm.linux.org.uk>
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca>
 <20101003112920.GB32736@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 3 Oct 2010 05:57:51 -0600
X-Google-Sender-Auth: vgQ6UTIl6MSV69B4Bd1K_Po1MBc
Message-ID: <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com>
Subject: Re: [patch 00/47] Sparse irq rework
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 3, 2010 at 5:29 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Oct 03, 2010 at 05:23:12AM -0600, Grant Likely wrote:
>> On Thu, Sep 30, 2010 at 11:14:27PM -0000, Thomas Gleixner wrote:
>> > The following patch series cleans up and mostly reimplements the core
>> > sparse irq implementation and sanitizes the most complex (ab)user:
>> > arch/x86
>>
>> Hoy Thomas,
>>
>> patches 1-13 & 15 all look fine to me.  Feel free to add my Acked-by:
>> line.
>>
>> Patch 14 seems to be missing, and by inference it appears that the
>> all important new allocator is added by patch 14.  All of the rest of
>> the series seems to be fine, but I'm forced to make assumptions about
>> what the new allocator looks like, so I cannot be positive.
>
> Patch 14 was present, you were even CC'd on it.

Hmmm... found it now.  I'm not sure what happened there, but I
couldn't find it the first time I looked.  Most likely it is a PEBKAC
failure.  Sorry for the noise.

Okay, patch 14 looks good to me too (including Yinghai's comment).
The new allocator seems sane, and I didn't see any obvious errors in
patches 16-47.  I've not tested any of this yet.  Hopefully I'll be
able to carve out some time to do so early this week.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
