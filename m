Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2HRTci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 15:32:38 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:42034 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2HRTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 15:32:23 -0400
Date: Sat, 18 Aug 2012 21:32:21 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
Message-ID: <20120818193221.GB250@x4>
References: <20120817171354.GA14046@kroah.com>
 <20120818060934.GA255@x4>
 <20120818163401.GA2013@kroah.com>
 <1345315025.10014.15.camel@joe2Laptop>
 <20120818185528.GA250@x4>
 <CA+55aFw48y=bZQq12-ySBiDT=ef6Yuq=eh6HLo6TGqyEK2kPkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw48y=bZQq12-ySBiDT=ef6Yuq=eh6HLo6TGqyEK2kPkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.08.18 at 12:24 -0700, Linus Torvalds wrote:
> On Sat, Aug 18, 2012 at 11:55 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> >
> > IOW:
> 
> Ack, that looks about right. Does that simple patch fix the issue for
> you?

Yes. Everything is fine again with this patch applied.

-- 
Markus
