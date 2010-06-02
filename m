Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0FBIuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:50:23 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:41525 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0FBIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:50:21 -0400
Date: Wed, 2 Jun 2010 10:50:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Am?rico Wang <xiyou.wangcong@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mmarek@suse.cz
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100602085018.GA6507@merkur.ravnborg.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <20100527154916.GA5585@infradead.org> <20100527184653.GA11830@merkur.ravnborg.org> <AANLkTikkZGdf8-WnHQu4dY6WiXH7d0Raak0j-82hrvAA@mail.gmail.com> <20100529111951.GB31550@merkur.ravnborg.org> <AANLkTiku0kPykE30DIQvOD9gauEGZbyeDWXGkLb53sgJ@mail.gmail.com> <20100602082039.GB5103@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100602082039.GB5103@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >> Although the patch touches only a generic file this is x86 specific.
> >>
> >
> >Américo Wang, Do you mind handle this kconfig patch.
> >
> 
> 
> Sorry for the delay.
> 
> Usually Michal should take this patch. Cc'ing him.

This is not generic functionality. The patch changes default
behaviour when building x86 kernes only.
So IMO it requires ack from the x86 maintainers.

	Sam
