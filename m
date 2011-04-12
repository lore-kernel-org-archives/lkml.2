Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1DLTWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:22:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab1DLTWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:22:07 -0400
Date: Tue, 12 Apr 2011 21:20:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Processes hang in an unkillable state
Message-ID: <20110412192059.GA14360@redhat.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com> <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com> <20110412182809.GA1218@redhat.com> <BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Robert Święcki wrote:
>
> On Tue, Apr 12, 2011 at 8:28 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I seem to understand...
> >
> > Please wait a bit, I need to recheck.
>
> Btw, Linus Torvalds is looking into a similar case in another thread -
> http://marc.info/?l=linux-kernel&m=130262886420218&w=2

Argh. thanks ;)

I'd wish I knew this before I started to investigate...

So, Linus's patch does the same, we can ignore the patch I sent.

Oleg.

