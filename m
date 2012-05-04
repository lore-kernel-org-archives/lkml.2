Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614Ab2EDXNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:13:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44932 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757894Ab2EDXNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:13:07 -0400
Message-ID: <1336173184.11505.25.camel@joe2Laptop>
Subject: Re: drivers: Probable misuses of ||
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Date: Fri, 04 May 2012 16:13:04 -0700
In-Reply-To: <20120504235630.6b79d938@pyramind.ukuu.org.uk>
References: <1333580415.23520.29.camel@joe2Laptop>
	 <1336168477.11505.6.camel@joe2Laptop>
	 <20120504235630.6b79d938@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 23:56 +0100, Alan Cox wrote:
> On Fri, 04 May 2012 14:54:37 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Wed, 2012-04-04 at 16:00 -0700, Joe Perches wrote:
> > > Likely these should be && not ||
> > > 
> > > drivers/scsi/FlashPoint.c:				if(bit_cnt != 0 || bit_cnt != 8)
> > 
> > It's been a month.
> > 
> > Do you maintainers not care about these obvious defects?
> 
> You are assuming the code in question has maintainers.

Nope.  I'm assuming the nominal subsystem maintainers
haven't bothered to look at it or are in "don't care"
mode and I am simply prompting people to look again.

Richard Weinberger replied showing that the flashpoint
bit was commented out.  Thanks Richard.

cheers, Joe


