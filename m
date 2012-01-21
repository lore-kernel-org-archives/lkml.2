Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2AUQLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 11:11:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40605 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2AUQLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 11:11:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAGAKE8-3k0FN5B91ff2XFpYuHfwB-bmr4b7EBEe-aSWfQr1mSw@mail.gmail.com>
References: <CAGAKE8_zLr9nrQ_-cXQGzycFo6746t8OzKK6DpCd9tcahyRfPQ@mail.gmail.com>
	<CAGAKE8_wL0GcbjDNWOw4sa8euxZyGDgkdW9EgohpmG48Qk3-nQ@mail.gmail.com>
	<CAO+b5-pZofpN7-e8H+toE98j24fby5u8_Nzfzkz_S31u5wDmwA@mail.gmail.com>
	<CAGAKE88--L1igeZFusU=TxRD6fyfKWZYhn7az6-xkS_mtVg8CA@mail.gmail.com>
	<CAGAKE8_b_Omxzg4C-VMiuM9aEhnRPkPD9=5DW9retGfcfOhBuQ@mail.gmail.com>
	<CAGAKE8-3k0FN5B91ff2XFpYuHfwB-bmr4b7EBEe-aSWfQr1mSw@mail.gmail.com>
Date: Sat, 21 Jan 2012 16:11:00 +0000
X-Google-Sender-Auth: eLv6Qq2FFck6azrTA9SXQCwUCnk
Message-ID: <CAO+b5-qsdn8i_BdAqJo_6CU3Lh6JTPSSsyg-m_bP+xcN5aBgxg@mail.gmail.com>
Subject: Re: [Scst-devel] BUG: Process hang when kvm crashed, stacktrace cfs+kvm
From: Bart Van Assche <bvanassche@acm.org>
To: kordex <kordex@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, peterz@infradead.org,
        kvm@vger.kernel.org, avi@redhat.com,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 2:58 PM, kordex <kordex@gmail.com> wrote:
> On Thu, Jan 19, 2012 at 21:12, kordex <kordex@gmail.com> wrote:
> > On Thu, Jan 19, 2012 at 20:34, kordex <kordex@gmail.com> wrote:
> >> Full dmesg of the case attached.
> >> On Thu, Jan 19, 2012 at 13:12, Bart Van Assche <bvanassche@acm.org> wrote:
> >>> On Thu, Jan 19, 2012 at 11:54 AM, kordex <kordex@gmail.com> wrote:
> >>>> > root@teletex:/usr/src/linux# dmesg
> >>>> > +0x12e7/0x1c50
> >>>> >  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
> >>>
> >>> The above output is truncated - the most interesting part is missing.
>
> Do I need to give you anything else? Any leads on what the problem
> might be? The machine is still running and in this state.

In the /proc/meminfo output I see that the system has 16 GB RAM and 33
GB swap memory. Also, MemFree + Buffers = 400 KB, which makes me
assume the system was under heavy memory pressure ?

Some essential information is still missing - the reason why the
kernel started spewing out all these call traces. Did someone hit the
SysRq key ? Is it because a task was hanging ? Was a BUG or WARNING
hit ?

Bart.
