Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0HWJBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:01:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:49617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0HWJBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:01:10 -0400
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 11:00:34 +0200
Message-ID: <1282554034.2605.1496.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 16:59 -0700, Linus Torvalds wrote:
> 
> Comments? Fixes? Braindamage? 

Running User Mode Linux (if it still builds) is a terrific test case for
the vma code. I remember that that was the thing that caused most
explosions back when I was poking at this code.

/me goes look at the actual patches..
