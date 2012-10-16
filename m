Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2JPRtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:49:04 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:18742 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2JPRtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:49:02 -0400
Message-ID: <1350409738.2785.30.camel@lorien2>
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: "Shin, Jacob" <Jacob.Shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        shuahkhan@gmail.com
Date: Tue, 16 Oct 2012 11:48:58 -0600
In-Reply-To: <8630fe28-0c1c-4f3a-90e1-df2d1b6615a6@blur>
References: <6ec48b96-afab-4c8b-ab74-2c640c2a161b@blur>
	 <8630fe28-0c1c-4f3a-90e1-df2d1b6615a6@blur>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 16:55 +0000, Shin, Jacob wrote:
> (Sorry for the top post, on mobile phone..) 
> 
> You can follow the latest thread here:
> https://lkml.org/lkml/2012/9/30/23
> 
> Yinghai's for-x86-mm branch should boot 1TB AMD with hoisting
> enabled. 
> 
> Thanks! 

Jacob,

Thanks. This includes several patches and large change. Good for
upstream, however won't go into stable trees. Any thoughts on a smaller
subset of changes that are suitable for stable kernels to enable HT?

Thanks,
-- Shuah
> 


