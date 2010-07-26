Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0GZHrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:47:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53916 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0GZHrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:47:47 -0400
From: Andi Kleen <andi@firstfloor.org>
To: dave.bueso@gmail.com
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] [PATCH procfs] Add process age
References: <1279907271.4335.3.camel@cowboy> <20100723183549.GA10518@x200>
	<1279910830.1851.5.camel@cowboy>
Date: Mon, 26 Jul 2010 09:47:45 +0200
In-Reply-To: <1279910830.1851.5.camel@cowboy> (Davidlohr Bueso's message of
	"Fri, 23 Jul 2010 14:47:10 -0400")
Message-ID: <87fwz6it0e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <dave.bueso@gmail.com> writes:

> On Fri, 2010-07-23 at 21:35 +0300, Alexey Dobriyan wrote:
>> On Fri, Jul 23, 2010 at 01:47:51PM -0400, Davidlohr Bueso wrote:
>> > This patch exports a process's age, in seconds, adding a /proc/#/age file.
>> 
>> What for?
>
> I have not found any straight way to get the run time of a processes,
> without having to interpret the start_time entry in /proc/#/stat and
> manually subtract the uptime from it.

That sounds like something an user space program should simply do.
Perhaps you can add it as a new optional "-o" field in "ps" ?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
