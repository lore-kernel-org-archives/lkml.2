Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1DUM2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:28:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49773 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1DUM2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:28:39 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=Ar9dcRiOBTsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=71CTC1Uxlh1s39ppzD0A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Reiser <jreiser@bitwagon.com>
In-Reply-To: <1303385773.7181.114.camel@gandalf.stny.rr.com>
References: <20110421022825.535486725@goodmis.org>
	 <20110421023737.290712238@goodmis.org>
	 <20110421094606.174caaf6@lxorguk.ukuu.org.uk>
	 <1303385773.7181.114.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Apr 2011 08:28:36 -0400
Message-ID: <1303388916.7181.119.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 07:36 -0400, Steven Rostedt wrote:
> I haven't done the "if (var = 1)" mistake since college.
> 
I have a very bad feeling that I just jinxed myself and within the year,
I'll submit a patch with that very mistake :-p

-- Steve


