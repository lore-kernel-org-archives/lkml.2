Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab2BGWfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:35:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59215 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2BGWfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:35:10 -0500
MIME-Version: 1.0
In-Reply-To: <1328592178.21268.78.camel@sli10-conroe>
References: <20120206151219.GC30752@redhat.com> <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com> <20120206203604.GC21292@google.com>
 <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
 <20120207003948.GE21292@google.com> <1328575430.21268.69.camel@sli10-conroe>
 <20120207005900.GF21292@google.com> <1328592178.21268.78.camel@sli10-conroe>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Feb 2012 14:34:48 -0800
X-Google-Sender-Auth: xxKc6Hqyw9kop7OC5p5KDnHObQk
Message-ID: <CA+55aFwv0WjXdz2SDKgzapCjm-b1mK=yFBW4PxnDGXorvTNpRA@mail.gmail.com>
Subject: Re: [patch]block: fix ioc locking warning
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 9:22 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Mon, 2012-02-06 at 16:59 -0800, Tejun Heo wrote:
>> * Test with the this_q != locked_q trylock patch.
> this one slightly reduces the regression. without it, the regression is
> about 17%, with it, the regression is about 12%. Test result is stable.

What happens when you remove the fast-case entirely?

See the other patch by Tejun with the subject "[PATCH] block: strip
out locking optimization in put_io_context()"

               Linus
