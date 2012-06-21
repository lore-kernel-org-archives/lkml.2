Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab2FUW1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:27:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53516 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925Ab2FUW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:27:44 -0400
Message-ID: <4FE39FC5.8060303@zytor.com>
Date: Thu, 21 Jun 2012 15:27:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Uros Vampl <mobile.leecher@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Aspire One Happy2 reboots only with the kbd method
References: <20120621133203.GA26316@zverina> <20120621142938.GZ32472@redhat.com> <4FE33278.20807@zytor.com> <20120621222228.GA27593@zverina>
In-Reply-To: <20120621222228.GA27593@zverina>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 03:22 PM, Uros Vampl wrote:
> 
> I advised the Arch user to join this discussion and provide the 
> requested info. I immediately went for kbd as the solution because 
> that's exactly what I need for my own Aspire One - that AOA110 quirk 
> that's visible in the context of this patch. I figured it's a pattern, 
> Aspire One machines quirky in the same way.
> 

Probably, but we'd like to figure out what is going on.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

