Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2BSVA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:00:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2BSVA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:00:29 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=v34b3tIZfGoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=c2dxCoxYReg9YQmvcCAA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to
 determine nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4F415F55.6050902@zytor.com>
References: <1329617173.1561.5.camel@acer.local.home>
	 <20120219125601.GD25900@elte.hu>
	 <0e44abc3-f1a9-4c5b-88a8-baa563f57067@email.android.com>
	 <1329683679.1561.20.camel@acer.local.home>  <4F415F55.6050902@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Feb 2012 16:00:31 -0500
Message-ID: <1329685231.1561.24.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 12:45 -0800, H. Peter Anvin wrote:

> User space can change %cs, but it can never set it to __KERNEL_CS; 
> specifically user space can never set the bottom two bits in CS to zero.
> 
> So this should be a better test.

Great! That means that my original patch (the one never submitted, but
tested) would be the best.

Ingo,

I'll send out another pull request with the old patch. I'll still run it
through tests just to be sure, so it may take a day before I send it.

(I hope I still have it)

> 
> (Now, doing the test that way plays havoc with the braindamage knows as 
> Xen paravirt, but I don't think it's subject to this particular NMI code.)

Xen paravirt shouldn't be doing nested NMIs. I hope :-)

-- Steve


