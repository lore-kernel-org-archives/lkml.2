Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1KUQLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:11:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42960 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1KUQLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:11:02 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=4dKo-c7JayoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Dno7G_uwZvRx3w_1JKEA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH][RT] tracing: Show padding as unsigned short
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CAONaPpF_urAKGRLy2Xv4ZXfDd7gT11jhdeOHpT2rjG42KW8Pcw@mail.gmail.com>
References: <1321467575.4181.36.camel@frodo>
	 <CAONaPpF_urAKGRLy2Xv4ZXfDd7gT11jhdeOHpT2rjG42KW8Pcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 11:11:00 -0500
Message-ID: <1321891860.20742.12.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 14:09 +0100, John Kacur wrote:

> 
> This one should also be included in 3.0.9-rt26
> Thanks

Yes it was added in -rt3, where my stable was based on -rt2. My scripts
picked it up when I ran it against -rt3.

-- Steve


