Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab1DZBtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:49:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42156 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab1DZBtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:49:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 0/4] blackfin: convet cpumask apis
Cc: kosaki.motohiro@jp.fujitsu.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        device-driver-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTi=WJytLPuKmiMYEHsVq4o=ESSY8MQ@mail.gmail.com>
References: <BANLkTinNhM5GwOKdS4hX==Wk71bTe-t4-w@mail.gmail.com> <BANLkTi=WJytLPuKmiMYEHsVq4o=ESSY8MQ@mail.gmail.com>
Message-Id: <20110426105045.F359.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 10:49:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 25, 2011 at 14:11, Mike Frysinger wrote:
> > On Mon, Apr 25, 2011 at 05:27, KOSAKI Motohiro wrote:
> >> Rusty Russle introduced a lot of cpumask related APIs. and He gone even
> >> though the work is unfinished. This patch series is sequel of his work.
> >>
> >> No functional change. only api change.
> >>
> >> note: I've confirmed only cross-compile build. so, I hope blackfin
> >> developers see the code.
> >
> > fyi, device-driver-devel@b.u.o is for general device drivers while
> > uclinux-dist-devel@b.u.o is for Blackfin arch work
> 
> oh, and i guess you typo-ed the list name since it's
> "device-drivers-devel" ;).  probably better to resend the series and
> not cc Michael (since he doesnt watch over Blackfin anymore).

I'm sorry. Will do.



