Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2JQPa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:30:58 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:6068 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2JQPa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:30:57 -0400
Message-ID: <1350487852.2741.13.camel@lorien2>
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        andreas.herrmann3@amd.com, borislav.petkov@amd.com,
        shuahkhan@gmail.com
Date: Wed, 17 Oct 2012 09:30:52 -0600
In-Reply-To: <507DAF3C.90903@zytor.com>
References: <6ec48b96-afab-4c8b-ab74-2c640c2a161b@blur>
	 <8630fe28-0c1c-4f3a-90e1-df2d1b6615a6@blur>
	 <1350409738.2785.30.camel@lorien2> <20121016182621.GA10857@jshin-Toonie>
	 <507DAF3C.90903@zytor.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 12:02 -0700, H. Peter Anvin wrote:
> On 10/16/2012 11:26 AM, Jacob Shin wrote:
> > 
> > HPA, it would be great if we can first get this patch upstream, and also
> > into the stable trees .. and after that, we can work on getting Yinghai's
> > mm refactoring in ..
> > 
> 
> I'll be back from travels tomorrow, I'll look at it then.

For what its worth, I applied this patch to RHEL 6.3 based on 2.6.32.
kernel and my test system came with 1 terabyte memory.

https://lkml.org/lkml/2011/10/20/323

Thanks,
-- Shuah



