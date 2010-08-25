Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0HYAqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:46:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39921 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0HYAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=D5kAAGIkqJPRodOIkaXricm4wOW/msmn3/VsVJV8mWsxEIzA304SE+RAKNArkqHqzp
         vpXfBUt71RQbZHxGxmsw==
MIME-Version: 1.0
In-Reply-To: <20100825093747.24085b28.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
	<20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikD3CFRPo7WvWwCnLQ+jzEs6rUk1sivYM3aRbGJ@mail.gmail.com>
	<20100825093747.24085b28.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 24 Aug 2010 17:46:03 -0700
Message-ID: <AANLkTi=KW_gxbmB14j5opSKL+-JFDFKO1YP6a7yvT8U5@mail.gmail.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 5:37 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Ou...I'm sorry but I would like to use attach_id() for this time.
> Forgive me, above seems a big change.
> I'd like to write a series of patch to do above, later.
> At least, to do a trial.
>

Sure, for testing outside the tree. I don't think introducing new code
into mainline that's intentionally ugly and cutting corners is a good
idea.

Paul
