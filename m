Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab0KRQdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:33:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39354 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab0KRQdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:33:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gkfovm5KHQ/01A+BX9xFCqRmHOTyd39SRAHqeIfTWQPjKMzkT5IOrRvsq7TnCrC8q4
         wWayWckpGL5ktiEVpM8gwg1eIruAstUUuiK1QaX4NvkRFdHvav6UKqkXMhD+mroHaS8u
         OAoY8U7NSfeuPjn1wa8d/FIpbzQnmdLF2m4Co=
Date: Thu, 18 Nov 2010 17:33:01 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 0/8] Dynamic clock devices
Message-ID: <20101118163301.GA6087@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <20101115100150.GA25973@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115100150.GA25973@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 07:01:50PM +0900, Paul Mundt wrote:
> While I have no strong feelings on this series one way or the other, the
> naming is a bit unfortunate. The clock device / clkdev naming is already
> in use as an extension to the clock framework and is used by a wide
> variety of embedded platforms already, with a pending patch to move it in
> to the generic namespace (grepping for clkdev will give you an idea). The
> idea behind that interface is similar in that it deals with the dynamic
> creation and teardown of clocks, but is decoupled from timekeeping.
> 
> It's also reasonable to assume that devices with dynamic clocks tracked
> through clkdev will wish to also use this interface in the timekeeping
> case, so it would be good to settle on something less ambiguous in
> advance.

Okay, I will take a look at that and try to come up with a better name
for the dynamic clock code.

Thanks,
Richard
