Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab1DYSSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:18:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33285 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab1DYSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=cHvlcB79+PnxA/nkD8geltN0zEGaKu2Qtmcstl9qTkgc8k9iFeCI2/zt3QB4J3AoFj
         DF4zaR+q93xkyR3e6VML15+Hjwk0SzBRHRo++Kj3sp7ECRF2RTK6jT4f0fzVJR28JJ3X
         2L8ibHQTbtBwZRDOM13sp4l35jotyA/4GKcgQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTinNhM5GwOKdS4hX==Wk71bTe-t4-w@mail.gmail.com>
References: <20110425182906.2673.A69D9226@jp.fujitsu.com> <BANLkTinNhM5GwOKdS4hX==Wk71bTe-t4-w@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 25 Apr 2011 14:18:26 -0400
Message-ID: <BANLkTi=WJytLPuKmiMYEHsVq4o=ESSY8MQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] blackfin: convet cpumask apis
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        device-driver-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 14:11, Mike Frysinger wrote:
> On Mon, Apr 25, 2011 at 05:27, KOSAKI Motohiro wrote:
>> Rusty Russle introduced a lot of cpumask related APIs. and He gone even
>> though the work is unfinished. This patch series is sequel of his work.
>>
>> No functional change. only api change.
>>
>> note: I've confirmed only cross-compile build. so, I hope blackfin
>> developers see the code.
>
> fyi, device-driver-devel@b.u.o is for general device drivers while
> uclinux-dist-devel@b.u.o is for Blackfin arch work

oh, and i guess you typo-ed the list name since it's
"device-drivers-devel" ;).  probably better to resend the series and
not cc Michael (since he doesnt watch over Blackfin anymore).
-mike
