Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0COSji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:39:38 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4518 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab0COSjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:39:37 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Mon, 15 Mar 2010 11:39:26 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "David Miller" <davem@davemloft.net>,
       "thisdyingdream@gmail.com" <thisdyingdream@gmail.com>,
       "sjharms@gmail.com" <sjharms@gmail.com>,
       "Matthew Carlson" <mcarlson@broadcom.com>,
       "Michael Chan" <mchan@broadcom.com>, "Benjamin Li" <benli@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sharms@ubuntu.com" <sharms@ubuntu.com>
Subject: Re: [PATCH] NET: tg3: fix brace, switch, and comma spacing
 coding style in tg3.c This is a patch to the tg3.c file that aligns
 switch and case statements, else statements following braces, and
 inserts a space after commas listed in the coding style g
Message-ID: <20100315183926.GA9159@xw6200.broadcom.net>
References: <b6bf7b051003131152t38c8b1e1m33e8844468b9e46a@mail.gmail.com>
 <20100313.115555.209991546.davem@davemloft.net>
 <1268511742.30289.74.camel@Joe-Laptop.home>
MIME-Version: 1.0
In-Reply-To: <1268511742.30289.74.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 6780A15438O142791158-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a patch awaiting net-next that does these kinds of things.  I
can roll (most of) Steven's changes into that patch and get it all
done in one shot if you like.

On Sat, Mar 13, 2010 at 12:22:22PM -0800, Joe Perches wrote:
> On Sat, 2010-03-13 at 11:55 -0800, David Miller wrote:
> > From: Steven Harms <thisdyingdream@gmail.com>
> > Date: Sat, 13 Mar 2010 14:52:26 -0500
> > 
> > > Would you like me to submit the patch adding only the spaces after
> > > commas and leave the rest of the defines as is, or discard the changes
> > > all together?
> > 
> > I would like you to toss them altogether.
> 
> I think that Steven got off on the wrong foot
> a bit by adding the parentheses to the defines.
> 
> I think the other changes he suggested are
> tree-wide style consistency only and are ok.
> 
> Perhaps you might reconsider later, after
> net-next reopens.
> 
> 
> 

