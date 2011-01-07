Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1AGQl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:41:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53583 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1AGQl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iT0Jk/dLyx5kK1uHo/c4o3xiWma0hNtXcIZR6kQyigXevf2VxHRpd6NSAfqhXlXGAt
         kK4fJh+7zhMCps59J7N348n6yBen+o2P/VlIXpxkycCUwOaK8wAi/PqEx+bJGfwpvd7v
         8J3WdV7g1cOcEtTRprck5/9/f6Oc2+4e7gS8c=
Date: Fri, 7 Jan 2011 17:41:49 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 09/13] posix clocks: introduce dynamic clocks
Message-ID: <20110107164149.GA8666@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <c28004fc5d121c1dd5f842550663fc9d6f55a114.1293820862.git.richard.cochran@omicron.at>
 <201101062056.22423.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101062056.22423.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 08:56:22PM +0100, Arnd Bergmann wrote:
> It should be just a trivial change and just affect how easy it is for
> other people to understand the code if they are already familiar
> with other kernel code.
 
Okay, I'll get right on it.

> Overall, your series looks really good now, it would be nice if this
> could still make it into 2.6.38.

Yes, that would be great.

Thanks,
Richard
