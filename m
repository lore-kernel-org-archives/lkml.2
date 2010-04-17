Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0DQQZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 12:25:35 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:39232 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0DQQZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 12:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=axFaVNgNPkhFAwGS9vze3jfSWMSXW7t9cZFhEqF6vE0ZHqCCr1yIDjR3Ww24hV9Sbi
         KQW1lLF4VvtW7p5RUG6IkTtliF9iMf5h9lJ6CeaKQ0k7oTSENwzbspCtj3o41xT9H4KH
         d9lHTi2FF4foBHCjZCwMfn+7VVxbQ7IOHVSfs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004162143300.3625@localhost.localdomain>
References: <cabda6421003230329w3fe596dbn8e4b37cc36118f9f@mail.gmail.com>
	 <1269340105-6503-1-git-send-email-chripell@fsfe.org>
	 <alpine.LFD.2.00.1004160110360.3625@localhost.localdomain>
	 <w2gcabda6421004160918vc5dc5ee2y14a5814b4e8573b3@mail.gmail.com>
	 <alpine.LFD.2.00.1004162143300.3625@localhost.localdomain>
Date: Sat, 17 Apr 2010 18:25:31 +0200
X-Google-Sender-Auth: 5ebfc8609cf17234
Message-ID: <g2xcabda6421004170925l8c824191t5d451434d24320ae@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] max3100: added raise_threaded_irq
From: christian pellegrin <chripell@fsfe.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: feng.tang@intel.com, akpm@linux-foundation.org, greg@kroah.com,
       david-b@pacbell.net, grant.likely@secretlab.ca,
       alan@lxorguk.ukuu.org.uk, spi-devel-general@lists.sourceforge.net,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Sat, Apr 17, 2010 at 12:06 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> I wonder whether we should restrict this mechanism to threaded
> handlers or just implement it in the following way:
>
.....
> This will not work out of the box when the irq is nested into some
> demultiplexing thread handler (IRQF_NESTED_THREAD).
>

OK, I see. The solution you proposed has many other uses such testing
of interrupt handlers in general. I will try to do some work along the
line you suggested next week.

Thank you!


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
