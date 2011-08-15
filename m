Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1HOHH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:07:28 -0400
Received: from mail.lang.hm ([64.81.33.126]:39596 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1HOHH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:07:27 -0400
Date: Mon, 15 Aug 2011 00:06:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: =?ISO-8859-15?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
cc: linux-kernel@vger.kernel.org, stable@linux.kernel.org
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick
 them).
In-Reply-To: <4E48C136.6090306@web.de>
Message-ID: <alpine.DEB.2.02.1108150004520.24266@asgard.lang.hm>
References: <20110815041524.GA7578@kroah.com> <4E48C136.6090306@web.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, J?rg-Volker Peetz wrote:

> Greg KH wrote, on 08/15/11 06:15:
> <snip>
>>
>> - a new -longterm kernel is picked every year.
>> - a -longterm kernel is maintained for 2 years and then dropped.
> <snip>
>
> Just a little nitpick: with this scheme you will accumulate longterm kernels. If
> I understand it right, one longterm kernel is added every year.

but with one new kernel being added each year, and then being dropped two 
years later, there are only 2 long term kernels at any one time (that Greg 
will be maintaining at least, nothing stops other people from maintaining 
other long term kernels in addition)

David Lang
