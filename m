Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1JSQZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:25:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1JSQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:25:35 -0400
Date: Wed, 19 Oct 2011 18:25:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Bromfield <s.bromfield@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        dm-cache@googlegroups.com
Subject: Re: [RFC][PATCH] dm-cache (block level disk cache target): UPDATE
Message-ID: <20111019162534.GI15908@one.firstfloor.org>
References: <CAGWyFtpaHvgDVV6DrM8L18eiDGrTL=teH6TZqfJNpwafE+-Big@mail.gmail.com> <m2aa8yymcl.fsf@firstfloor.org> <CAGWyFtpxuGnOhw7ukE2J+aQddLx6FtnSBvwV=RFaB7-c81GeNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGWyFtpxuGnOhw7ukE2J+aQddLx6FtnSBvwV=RFaB7-c81GeNA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 12:17:58PM -0400, Stephen Bromfield wrote:
> Mr.  Kleen,
> 
> We are working to make a patch for the 3.1 kernel. Till the patch is
> complete, we hope that some of our users can benefit from this update.
> As for your other comments, DM-cache is a work in progress and we will
> try to address some of your issues in later patches. Thanks for your
> feedback.

Given the GFP_KERNEL issues in the IO path I have doubts the whole
thing will run reliably under high load / low memory.

So you should probably mark it "experimental / may eat your data"
for now.

-Andi
