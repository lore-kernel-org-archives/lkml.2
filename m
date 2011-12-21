Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1LUEvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:51:16 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46791 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1LUEvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:51:12 -0500
Date: Tue, 20 Dec 2011 23:50:51 -0500 (EST)
Message-Id: <20111220.235051.89878848481025900.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rjw@sisk.pl, shaggy@kernel.org, jfs-discussion@lists.sourceforge.net,
        kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
        maciej.rutecki@gmail.com, akpm@linux-foundation.org,
        florian@mickler.org
Subject: Re: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFzee7ORKzjZ-_PrVy796k2ASyTe_Odz=ji7f1VzToOkKw@mail.gmail.com>
References: <201112210054.46995.rjw@sisk.pl>
	<CA+55aFzee7ORKzjZ-_PrVy796k2ASyTe_Odz=ji7f1VzToOkKw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 20 Dec 2011 20:50:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Dec 2011 18:31:15 -0800

> On Tue, Dec 20, 2011 at 3:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> Subject    : Sparc-32 doesn't work in 3.1.
>> Submitter  : Rob Landley <rob@landley.net>
>> Date       : 2011-11-12 11:22
>> Message-ID : 4EBEAB5A.5020809@landley.net
>> References : http://www.spinics.net/lists/kernel/msg1260383.html
> 
> I'm pretty sure this is fixed by commit b1f44e13a525.

It is.
