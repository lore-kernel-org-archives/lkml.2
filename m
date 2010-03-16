Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab0CPH4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:56:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48788 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0CPH4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:56:48 -0400
Message-ID: <4B9F39BE.40502@cs.helsinki.fi>
Date: Tue, 16 Mar 2010 09:56:46 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>	 <20100316061718.GA22651@elte.hu>	 <84144f021003152358r41a79ccaxb18cf6368911266@mail.gmail.com> <b6fcc0a1003160015j2926b2a2w4e7808939c4144d6@mail.gmail.com>
In-Reply-To: <b6fcc0a1003160015j2926b2a2w4e7808939c4144d6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan kirjoitti:
> On Tue, Mar 16, 2010 at 8:58 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> We should avoid creating tree-wide breakage for this kind of cleanups.
> 
> This is done by compile testing, not by being smartass.

I don't think compile testing is going to scale here because slab is 
used is so many places of the kernel.

			Pekka
