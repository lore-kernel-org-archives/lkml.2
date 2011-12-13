Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1LMXQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:16:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39728 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab1LMXQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:16:06 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=eGShEhoz2TEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=mEJv2xgy1aRY1wSJM5EA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323818162.23971.6.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 13 Dec 2011 18:16:02 -0500
In-Reply-To: <1323817697.23971.5.camel@gandalf.stny.rr.com>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org>
	 <1323812733-7520-2-git-send-email-andi@firstfloor.org>
	 <alpine.LFD.2.02.1112132336440.3020@ionos>
	 <20111213225617.GC7633@tassilo.jf.intel.com>
	 <1323817697.23971.5.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 18:08 -0500, Steven Rostedt wrote:

> We hit this with trace events as well, 

Here's the commit if you were interested:

e4a9ea5ee7c8812a7bf0c3fb725ceeaa3d4c2fcc

-- Steve


