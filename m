Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab1DYRvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:51:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45717 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab1DYRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=STfMlNTeFDSHkFRxIH0G+8aSS9ku6lVfb62inqWwIlZsSXIMKyhdBV0xC1KX4IHPFf
         dJg6K2HG6qzimorKX18eBTbHkUgNSiVhJBb89parQAYWqDFqAIUeOhBcto+d3LbKR6Gh
         q8OTSqzVQnsUSac+/ZrLtupjQtUGPpPGURsMk=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com>
References: <20110424202158.45578f31@neptune.home>
	<20110424235928.71af51e0@neptune.home>
	<20110425114429.266A.A69D9226@jp.fujitsu.com>
	<BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com>
	<20110425111705.786ef0c5@neptune.home>
	<BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com>
Date: Mon, 25 Apr 2011 20:51:01 +0300
X-Google-Sender-Auth: 38WoNBwXtJf6ocLtU9gGVM_j0Ss
Message-ID: <BANLkTikSEg-+4==08FSTpPsRKOxW-o7ftg@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 6:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> (Pekka? This is a real _problem_. The whole "confused debugging" is
> wasting a lot of peoples time. Can we please try to get slabinfo
> statistics work right for the merged state. Or perhaps decide to just
> not merge at all?)

I sent proof of concept patches that hopefully fix SLUB statistics for
merged case. Lets see what Christoph and David think of them and if
it's a dead end, I'd be inclined to rip out slab merging
completely....

                       Pekka
