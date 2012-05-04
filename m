Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545Ab2EDWx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:53:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59637 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2EDWx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:53:57 -0400
Date: Fri, 4 May 2012 23:56:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: drivers: Probable misuses of ||
Message-ID: <20120504235630.6b79d938@pyramind.ukuu.org.uk>
In-Reply-To: <1336168477.11505.6.camel@joe2Laptop>
References: <1333580415.23520.29.camel@joe2Laptop>
	<1336168477.11505.6.camel@joe2Laptop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2012 14:54:37 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-04-04 at 16:00 -0700, Joe Perches wrote:
> > Likely these should be && not ||
> > 
> > drivers/scsi/FlashPoint.c:				if(bit_cnt != 0 || bit_cnt != 8)
> 
> It's been a month.
> 
> Do you maintainers not care about these obvious defects?

You are assuming the code in question has maintainers. FlashPoint hasn't
really had a maintainer since Leonard died. Also given it's been like
that for approaching twenty years and works there is a real danger in
changing it unless the patch is tested carefully - if you can find anyone
with the hardware.

It's not unknown for code to work *because* it is wrong.

Alan
