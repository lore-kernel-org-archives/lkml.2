Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1DZTJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:09:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39578 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1DZTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:09:17 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=Ar9dcRiOBTsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Y73rfEG-K5SVbGcFCHoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
From: Steven Rostedt <rostedt@goodmis.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: John Reiser <jreiser@bitwagon.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <BANLkTinENP=hpjZBMFp0Y7EKGH8u-gewPA@mail.gmail.com>
References: <20110421022825.535486725@goodmis.org>
	 <20110421023737.290712238@goodmis.org> <4DB19A1E.8070806@bitwagon.com>
	 <BANLkTim8mBo3fz9f=quABj-=ycpA+G7q1g@mail.gmail.com>
	 <1303488341.6225.2.camel@gandalf.stny.rr.com>
	 <BANLkTinENP=hpjZBMFp0Y7EKGH8u-gewPA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 15:09:15 -0400
Message-ID: <1303844955.18763.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 15:52 -0300, Thiago Farina wrote:
> Hi,

> I've sent a patch to linux-kernel adding streq macro as suggested and
> copied you Steven.

Yep, saw it. If it is accepted, then I'll start conversions to it.

-- Steve


