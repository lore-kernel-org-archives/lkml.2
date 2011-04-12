Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1DLWNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:13:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932628Ab1DLWNv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:13:51 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinjGkbBMUo7MQ2Dg2yDwQ932qJ7rQ@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
 <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com> <20110412182809.GA1218@redhat.com>
 <BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com> <20110412192059.GA14360@redhat.com>
 <BANLkTimJgx_x=0bpBDWaUkJgZPYs3_iwsg@mail.gmail.com> <BANLkTimBegMUq2fX67o2YnoATWG-NDbKgA@mail.gmail.com>
 <BANLkTikoDELrA-RtA9BLm64mfoPgdADR0Q@mail.gmail.com> <BANLkTi=HyK+8DhJS3db0j2fefdOjwVMN3w@mail.gmail.com>
 <BANLkTinMAGmdEDviRwZ1-mxrAAe_WK5jvg@mail.gmail.com> <BANLkTinjGkbBMUo7MQ2Dg2yDwQ932qJ7rQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 15:12:58 -0700
Message-ID: <BANLkTikRH0q3RyP_CORXjAX34-br4pqf=A@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 2:59 PM, Robert Święcki <robert@swiecki.net> wrote:
>
> Compiling now with CONFIG_OPTIMIZE_SIZE and vma dump code. Will
> probably post some results tomorrow.

.. and if you've added my patch to the stack growth case, hopefully
there won't _be_ any results ;)

                     Linus
