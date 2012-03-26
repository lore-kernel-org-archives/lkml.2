Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab2CZQrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:47:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19802 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2CZQra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:47:30 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hkKkbzRNYrQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=k1_-dt6Pt4EOdDOjOQkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332780448.23924.104.camel@gandalf.stny.rr.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Steven Rostedt <rostedt@goodmis.org>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 12:47:28 -0400
In-Reply-To: <CAB4K4y46ATRL84XXYf6jYK3R9S_7JKV7hLOWa+PZgZh4eW5j9Q@mail.gmail.com>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	 <20120319130445.GN15988@n2100.arm.linux.org.uk>
	 <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	 <20120319132623.GO15988@n2100.arm.linux.org.uk>
	 <4F696011.7080409@linaro.org>
	 <CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	 <CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	 <20120322100236.GS15988@n2100.arm.linux.org.uk>
	 <CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
	 <4F6BECA7.7030007@linaro.org>
	 <CAB4K4y4DvUb+908P4NJoyJbDa35R2jP5cHqnoNWr9HRZJYyj4w@mail.gmail.com>
	 <1332512896.23924.66.camel@gandalf.stny.rr.com>
	 <CAB4K4y46ATRL84XXYf6jYK3R9S_7JKV7hLOWa+PZgZh4eW5j9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 12:36 +0530, Ajeet Yadav wrote:

> Hi Steve thanks for review, is their anything more I can do or shall I
> consider this change as already submitted, thanks everyone for helping
> me.
> >
> >

I can pull this in. Do they need to go into 3.4? Or can you wait till
3.5?

-- Steve



