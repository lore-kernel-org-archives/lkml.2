Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1GLVtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:49:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47431 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1GLVtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110712212920.GQ2326@linux.vnet.ibm.com>
References: <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
	<20110710171626.GK6014@linux.vnet.ibm.com>
	<20110710173530.GA16954@linux.vnet.ibm.com>
	<CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
	<20110710214639.GP6014@linux.vnet.ibm.com>
	<CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
	<20110710231449.GQ6014@linux.vnet.ibm.com>
	<CAAVPGOMSprJSkzziH6hJv9PweOONzsMaRZEK2ZSrV3xFBReTPw@mail.gmail.com>
	<20110711214301.GP2245@linux.vnet.ibm.com>
	<CAAVPGOOJ0NEWqF2w9zCLC1bpXeA_TwzenNo-a4kvR3tcbewnNw@mail.gmail.com>
	<20110712212920.GQ2326@linux.vnet.ibm.com>
Date: Tue, 12 Jul 2011 22:49:22 +0100
Message-ID: <CAAVPGOPnHb0E=vutOEQwqsUTo-wrj6_-dEv7tW096yyppMgWcw@mail.gmail.com>
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
From: Julie Sullivan <kernelmail.jms@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> If this is the correct one, then the upstreamable patch I sent recently
> (https://lkml.org/lkml/2011/7/12/313) should also work.  Famous last
> words...
>
>                                                        Thanx, Paul


Indeed this works, applied to a clean v3.0-rc4  (!CONFIG_RCU_BOOST 64-bit build)

Great job, Paul, thanks for all your efforts.
I'll test it tomorrow too on -rc5, 6 and 7 (out of time for tonight)

Cheers
Julie
