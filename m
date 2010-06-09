Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab0FIXOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:14:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab0FIXOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:14:37 -0400
Date: Wed, 9 Jun 2010 16:14:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
In-Reply-To: <20100609155321.299cadd9@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.1006091611040.4506@i5.linux-foundation.org>
References: <20100609155321.299cadd9@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Jesse Barnes wrote:
> 
> Nothing too big here; I do have a couple of fixes in the queue that
> aren't included here though.  I'll be pulling them together over the
> next couple of days.

Hmm. None of these seem to really be relevant. The fact that one is from 
me doesn't make me any more eager to pull. Are any of these real 
regressions (the missing parenthesis one seems to be the only one that 
could be serious, but I didn't grep for actual use).

			Linus
