Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2JKHT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:19:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52700 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2JKHTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:19:53 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Meaningless load?
From: Simon Klinkert <simon.klinkert@gmail.com>
In-Reply-To: <1349886164.1279.20.camel@twins>
Date: Thu, 11 Oct 2012 09:19:49 +0200
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Trond.Myklebust@netapp.com
Content-Transfer-Encoding: 8BIT
Message-Id: <8CCB73B0-34AD-47E2-9379-DB6F02DB35F5@gmail.com>
References: <98F2F644-D531-42FE-B080-9561142D71C8@gmail.com> <1349886164.1279.20.camel@twins>
To: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10.10.2012, at 18:22, Peter Zijlstra  wrote:

> On Wed, 2012-10-10 at 17:44 +0200, Simon Klinkert wrote:
>> I'm just wondering if the 'load' is really meaningful in this
>> scenario. The machine is the whole time fully responsive and looks
>> fine to me but maybe I didn't understand correctly what the load
>> should mean. Is there any sensible interpretation of the load?
> 
> I'll leave meaningful aside, but uninterruptible (D state) is part of
> how the load thing is defined, so your 500 result is correct.

Yes, the calculation of the load is correct but I still don't know how I should interpret the load…

On 11.10.2012, at 06:02, Mike Galbraith wrote:

> Makes perfect sense to me.  Work _is_ stack this high.  We don't and
> can't know whether the mountain is made of popcorn balls or boulders.

That's the point. Afaik the D state never represents 'work'. These processes are waiting for something.

Let's say we have 10,000 processes in the D state (and thus a load of ~10,000) doing nothing. What should the load tell me? The machine is under fire? There is nothing to do? There might be something to do but the machine doesn't know?

Simon


