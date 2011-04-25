Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1DYWIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:08:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55062 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1DYWIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=whzFQcj8hYTg3b1ElrKKGLnpj72CiMiCTdVZmtrnezt9MpJHpsqhrs/Fp0MGFXb9pd
         krcnZwXsHQgNX8OVNwCZK9DPNj5aPIbR5jCtvXXwylu21kRrVm6pVtDMgol3X8tsH1O4
         Yx1J+efEswgcwIRkecCS8CLOnIsTh56GS1tR8=
MIME-Version: 1.0
In-Reply-To: <20110425231016.34b4293e@neptune.home>
References: <20110424235928.71af51e0@neptune.home> <20110425114429.266A.A69D9226@jp.fujitsu.com>
 <BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com> <20110425111705.786ef0c5@neptune.home>
 <BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com> <20110425180450.1ede0845@neptune.home>
 <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com> <20110425190032.7904c95d@neptune.home>
 <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com> <20110425203606.4e78246c@neptune.home>
 <20110425191607.GL2468@linux.vnet.ibm.com> <20110425231016.34b4293e@neptune.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 25 Apr 2011 18:08:32 -0400
Message-ID: <BANLkTinQwJj481vFw4X5K7cOVMWjRqx-xg@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/25 Bruno Prémont:
> With + + TREE_PREMPT_RCU system was stable compiling for over 2 hours,
> switching to TINY_RCU, filp count started increasing pretty early after beginning
> compiling.

since you can reproduce fairly easily, could you try some of the major
rc's to see if you could narrow down things ?  see if 2.6.39-rc[123]
all act the same while 2.6.38 works ?
-mike
