Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1BBHvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:51:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40745 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBHvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:51:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AA4iAcBXBFRxg3j8quM2SZlVtQh34dmmaHASYYqAcpC+H3OluLJC+ounn2tWPLEasC
         y+UCwEFEb4ESPM8Etv7pkItxUl2oIc+ebDqo44rcZ3TkYbrhlilZ8azVs4fIjyR/sqQz
         OqRm/pL7ztwsmi4p1Mp/Hkum69QN+Jto5LLLY=
Date: Wed, 2 Feb 2011 08:50:59 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
Message-ID: <20110202075058.GA2747@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <20110201134420.164172635@linutronix.de>
 <1296596987.3336.83.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296596987.3336.83.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:49:47PM -0800, john stultz wrote:
> I sort of worry about the naming collision with the term posix-clock, as
> this is just one type of posix clock (I suspect most folks think of a
> posix clock as the clockid passed to the existing posix api).
> 
> Could we maybe use posix-dynclock or posix-fdclock or something? I know
> its already been changed from clkdev, so sorry for being finicky here
> and not catching this earlier.

A rose by any other name...

I agree that naming (even internal APIs) is important and have no
objection to changing the name. I did spend a bit of time considering
various alternatives, and now I'm out of ideas.

So, please do change the name if you have a better one.

Thanks,
Richard
