Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1CYTxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:53:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1CYTxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:53:10 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=s8bQjA_BN_cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=psVRvG15vVdg5EZTR4sA:9 a=TiLsxaH2z-i2nONOCnkA:7 a=FOaH4DpsctEbIfonX081Hb9vmCMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements
 on UP
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110325194729.GA6192@p183.telecom.by>
References: <20110317192208.444147791@goodmis.org>
	 <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
	 <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
	 <1301076981.14261.197.camel@gandalf.stny.rr.com>
	 <1301077163.14261.199.camel@gandalf.stny.rr.com>
	 <20110325193128.GA5839@p183.telecom.by>
	 <1301082034.14261.202.camel@gandalf.stny.rr.com>
	 <20110325194729.GA6192@p183.telecom.by>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 15:53:08 -0400
Message-ID: <1301082788.14261.204.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 21:47 +0200, Alexey Dobriyan wrote:

> I always thought if (WARN_ON(x)) is confusing and should be banned.

I think that's the preferred method (I use it all the time).

	if (WARN_ON(blah))
		goto fail;

Better than:

	if (x) {
		WARN_ON(1);
		goto fail;
	}

-- Steve


