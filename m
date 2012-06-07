Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab2FGFxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 01:53:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42426 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2FGFxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 01:53:01 -0400
Date: Thu, 7 Jun 2012 14:52:56 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] parisc fixes for 3.4-rc1
Message-ID: <20120607055256.GA15428@kroah.com>
References: <1339047493.26595.7.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339047493.26595.7.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 02:38:13PM +0900, James Bottomley wrote:
> This is a set of three bug fixes for minor build breakages that got
> introduced just before 3.4-rc1 was released.

3.4-rc1 or 3.5-rc1?  I ask as if this is 3.4-rc1, these should go to the
stable tree, right?

greg k-h
