Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1JYUkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:40:32 -0400
Received: from natasha.panasas.com ([67.152.220.90]:38169 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1JYUkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:40:31 -0400
Message-ID: <4EA71EB5.4090401@panasas.com>
Date: Tue, 25 Oct 2011 13:40:21 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Please re-enable the git-commits-head mailing list
References: <4EA6EA6F.1020602@panasas.com> <20111025134800.4da48376@tpl.lwn.net>
In-Reply-To: <20111025134800.4da48376@tpl.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 12:48 PM, Jonathan Corbet wrote:
> On Tue, 25 Oct 2011 09:57:19 -0700
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Since the brain stroke of vger.kernel.org we stopped getting any messages on
>> git-commits-head@vger.kernel.org It is important because of the mirroring delay of the gits which
>> can take 24 h in some places. And because it is a very convenient way to look for something or in
>> general keep track of what's going on.
>>
>> Please re-enable it. It should be as simple as:
>> 	git config --add hooks.mailinglist "git-commits-head@vger.kernel.org"
> 
> The commits list was discussed at the kernel summit.  The people who
> are working to piece kernel.org together are aware of the value of this
> list and will arrange for it when they can.  As I understand it, the
> first priority remains getting the git trees back onto kernel.org to
> support the merge window, though.
> 
> jon

Thanks Jonathan.

Most important that it was not forgotten. We can wait a merge window that's
fine.

Thanks
Boaz

