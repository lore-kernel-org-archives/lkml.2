Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0CXGfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 02:35:11 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0CXGfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 02:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=gQBI2tkriIJxgFDl7xhcYcL3nsV9u2csFIVmbkuxy7qcv1ZYmqC7JfnqLBu7Lgx/Dq
         LxIBdh0g1OGJEVzlqXYLkGsGxR0OWm1rtf/kG0p+TKPM+XV/DRncmaMqSYauOXDZvgt3
         qp1y8J/fCxKzWUNsU36MP9+CV3/BEfhI9+bVc=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Ferenc Wagner <wferi@niif.hu>, Phillip Lougher <phillip.lougher@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>
	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
	<8739zqpxxw.fsf@tac.ki.iif.hu> <4BA9A1BB.4000105@lougher.demon.co.uk>
Date: Wed, 24 Mar 2010 07:35:01 +0100
In-Reply-To: <4BA9A1BB.4000105@lougher.demon.co.uk> (Phillip Lougher's message
	of "Wed, 24 Mar 2010 05:23:07 +0000")
Message-ID: <87y6hii5wq.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Phillip" == Phillip Lougher <phillip@lougher.demon.co.uk> writes:

Hi,

 Phillip> BTW as a comparison, I have added MTD support to Squashfs
 Phillip> twice in the past, *with* bad block support.  The latest has a
 Phillip> diff patch of ~500 lines, with far less complexity and code
 Phillip> changes necessary.

Could we merge that then please?

Again, what kind of size reduction can we expect from getting rid of the
block layer?

-- 
Bye, Peter Korsgaard
