Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab2FGF7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 01:59:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60035 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab2FGF7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 01:59:02 -0400
Message-ID: <1339048740.26595.8.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [GIT PULL] parisc fixes for 3.4-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 07 Jun 2012 14:59:00 +0900
In-Reply-To: <20120607055256.GA15428@kroah.com>
References: <1339047493.26595.7.camel@dabdike.int.hansenpartnership.com>
	 <20120607055256.GA15428@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 14:52 +0900, Greg KH wrote:
> On Thu, Jun 07, 2012 at 02:38:13PM +0900, James Bottomley wrote:
> > This is a set of three bug fixes for minor build breakages that got
> > introduced just before 3.4-rc1 was released.
> 
> 3.4-rc1 or 3.5-rc1?  I ask as if this is 3.4-rc1, these should go to the
> stable tree, right?

Sorry, mislabel ... it's 3.5-rc1 ... they all fix breaks that were
introduced within the last week, so no need for a stable backport.

James


