Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1FAUGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:06:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab1FAUGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:06:04 -0400
Date: Wed, 1 Jun 2011 22:04:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, indan@nul.nu,
        Tejun Heo <tj@kernel.org>, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org, jan.kratochvil@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110601200424.GA9981@redhat.com>
References: <20110523124314.GA7232@redhat.com> <20110524102834.GC10334@htj.dyndns.org> <20110525182919.GB16575@redhat.com> <20110526091401.GD9715@htj.dyndns.org> <20110526150150.GD12525@redhat.com> <20110527182121.GA3212@mtj.dyndns.org> <20110530192255.GB20616@redhat.com> <BANLkTimupSd774N-VBoswOj+Dza=5ofvWQ@mail.gmail.com> <20110531190809.GA20691@redhat.com> <BANLkTinEXW=nS6KoH7SKHbTit=nKfG7NOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinEXW=nS6KoH7SKHbTit=nKfG7NOw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Linus Torvalds wrote:
>
> On Wed, Jun 1, 2011 at 4:08 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > On a seriouse note, of course you are right, but what we should do?
>
> Have we *ever* gotten a bug-report about these kinds of things from
> actual users?

Yes ;) https://bugzilla.redhat.com/show_bug.cgi?id=705583

> IOW, it may be an annoying issue from a theoretical standpoint, but
> afaik it's not an annoying issue from a practical user standpoint.

Probably...

Oleg.

