Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1ESEcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:32:54 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:45127 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781Ab1ESEcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:32:53 -0400
X-Sasl-enc: pDTDi38EHS/iI1gEiVDKQU16J4Z3qc55Q9H6lX9wnTH0 1305779572
Date: Wed, 18 May 2011 21:30:53 -0700
From: Greg KH <greg@kroah.com>
To: anish singh <anish198519851985@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: patch for Checkpatch.pl
Message-ID: <20110519043053.GA10187@kroah.com>
References: <BANLkTikYRvHb0ffdpdzpiTh7S+Ayxw1wew@mail.gmail.com>
 <20110519035803.GA9867@kroah.com>
 <BANLkTimNqAwy8S9EF2KMU_af4Q+RoXsuqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimNqAwy8S9EF2KMU_af4Q+RoXsuqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 09:33:08AM +0530, anish singh wrote:
> 
> 
> On Thu, May 19, 2011 at 9:28 AM, Greg KH <greg@kroah.com> wrote:
> 
>     On Thu, May 19, 2011 at 08:39:57AM +0530, anish singh wrote:
>     > I am thinking of submitting a patch for checkpatch.pl.
>     >  
>     > Ideally it should give a warning when there is no space between
>     > patch submitter name and the email id as below:
>     > Signed-off-by: anish kumar<anish@gmail.com>
>     >  
>     > It should be as below:
>     > Signed-off-by: anish kumar <anish@gmail.com>
>     >  
>     > Please let me know if it is fine.I will send it right away as i have
>     > it ready.
> 
>     As you are the only one I have ever seen do this before, I doubt it's
>     really needed for the checkpatch script, right?
> 
> Yes my bad but when we don't add space after Signed-off-by:_
> it says that space is required.So thought this is also required.
> Anyway if it is not needed i am ok.

If it's a simple patch, that's fine, send it in.

