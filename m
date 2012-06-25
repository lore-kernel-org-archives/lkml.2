Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2FYOs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:48:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab2FYOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:48:55 -0400
X-Authority-Analysis: v=2.0 cv=bpjO9Tmi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=C_U1be-mfRQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=kbg3vzUf44lj4uVifhoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340635734.27036.327.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Revert the buffered-printk() changes for now
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 25 Jun 2012 10:48:54 -0400
In-Reply-To: <20120625140748.GB1301@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
	 <20120623061313.GA21895@gmail.com> <1340452052.1784.40.camel@mop>
	 <20120625090933.GD24512@gmail.com>
	 <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
	 <20120625140748.GB1301@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 16:07 +0200, Ingo Molnar wrote:

> System logging is an arguably secondary role, and it should not 
> degrade printk()s primary role.

I would argue that printk() should not play the role of normal system
logging. It's main role should be for boot up and crashes. If devices
need to log information to userspace, it should really use some other
means. What was /sys made for anyway?

-- Steve


