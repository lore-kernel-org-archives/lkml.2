Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1HRQAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:00:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43895 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab1HRQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:00:50 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Dan Merillat <dan.merillat@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: processes stuck in llseek
In-reply-to: <CAKcLGm-c8zEi+=j2M_QjvS3GGJezvN_DTbUwb-tZtjPj9ZhNrQ@mail.gmail.com>
References: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com> <1313499055-sup-2296@shiny> <CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com> <4E4B181E.8000508@cn.fujitsu.com> <CAKcLGm-c8zEi+=j2M_QjvS3GGJezvN_DTbUwb-tZtjPj9ZhNrQ@mail.gmail.com>
Date: Thu, 18 Aug 2011 12:00:27 -0400
Message-Id: <1313683211-sup-3134@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4E4D372B.007D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Mitch Harder's message of 2011-08-18 11:40:17 -0400:
> On Tue, Aug 16, 2011 at 8:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> > Dan Merillat wrote:
> >> On Tue, Aug 16, 2011 at 8:51 AM, Chris Mason <chris.mason@oracle.com> wrote:
> >>> Excerpts from Dan Merillat's message of 2011-08-15 23:59:50 -0400:
> >>
> >>> Dan Carpenter sent a patch for this, I'll get it queued up for rc3.
> >>
> >> Can you send it?  I'd like to test it to see if it fixes my system.
> >
> > Here it is.
> >
> > http://marc.info/?l=linux-btrfs&m=131176036219732&w=2
> >
> 
> Doesn't this patch rely on Josef's SEEK_HOLE/SEEK_DATA patch set which
> isn't in the kernel yet?
> 
> http://marc.info/?l=linux-btrfs&m=130927580606177&w=2

It does, but the hang was reported on 3.1-rc1, which does have Josef's
code.

-chris
