Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0JLQAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:00:33 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:54124 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837Ab0JLQAc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:00:32 -0400
X-AuditID: 1209190e-b7b3bae000000a71-64-4cb48627fdc2
Subject: Re: Kernel Scalability to 48 cores
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <87wrpn1nwy.fsf@basil.nowhere.org>
Date: Tue, 12 Oct 2010 12:00:27 -0400
Cc: Cyrus Massoumi <cyrusm@gmx.net>, LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <585FC89B-C279-485E-9AE4-6ABA0F5EE4CE@mit.edu>
References: <4CB381DB.1040206@gmx.net> <87wrpn1nwy.fsf@basil.nowhere.org>
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAARZDab4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2010, at 10:33 AM, Andi Kleen wrote:

> The paper is known, but it seems to be in the usual unproductive 
> "publish a paper, but don't care about fixing anything" acedemic mode.

The thing I found most disappointing about the paper is that it describe techniques that have been in use in industry to provide better scalability to commerical OS's, and which were first applied to Linux something like a decade ago.

Sure, at the time we were going to 4-16 way scalability, but the techniques used were known back then, and in fact the paper is actually pretty naive compared to what people at companies like Sequent had been doing for a very long time.

It's just that a lot of scalability work took a bit of a hiatus, oh, five years ago because at the time, Linux was good enough, and adding more scalability has costs (which is why not all of the changes SGI made for 512 and 1024-way scalability have not necessarily found their way into mainline).   The fact that we've needed to worry about scalability now that 6+ cores/socket are available now, and many more are coming soon, is something we've known for at least the last year or two. 

But since a lot of that work wasn't published in the appropriate hoidy-toidy "tenure-track" approved publication venues, to the academics, it didn't exist.

Oh, well....

-- Ted

