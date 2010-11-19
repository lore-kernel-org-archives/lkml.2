Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0KSMzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:55:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:41386 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0KSMze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:55:34 -0500
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: Peter Zijlstra <peterz@infradead.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
In-Reply-To: <AANLkTinrk8XN9XQeM-pmqhiz=tSw4x01JaGMjdRG52dF@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	 <1290165768.2109.1537.camel@laptop>
	 <AANLkTik3ujs7-tMNUuk33wuMXFm+iusspMcR=yjPXtn_@mail.gmail.com>
	 <1290168173.2109.1565.camel@laptop>
	 <AANLkTinrk8XN9XQeM-pmqhiz=tSw4x01JaGMjdRG52dF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 13:55:15 +0100
Message-ID: <1290171315.2109.1577.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 20:48 +0800, huang ying wrote:
> 
> I have talked with Mauro during LPC. We all agree that we need a
> generic hardware error reporting interface. And now, I want to talk
> with all interested parties with code. 

talking with code could maybe be done.. but definitely not in the form
of a 'pull' request of your approach.

Also, I would think that if you do a RFC (the usual way to talk with
code) is to list the various requirements and how you address them with
your code and asking the other parties if the agree with the approach
you've taken.

You've done none of that, instead you ask Len to merge your muck without
even mentioning what the other parties think.
