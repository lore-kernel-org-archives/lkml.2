Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2BFNbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 08:31:13 -0500
Received: from natasha.panasas.com ([67.152.220.90]:33908 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2BFNbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 08:31:12 -0500
Message-ID: <4F2FD60D.5090708@panasas.com>
Date: Mon, 6 Feb 2012 15:30:53 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Please re-enable the git-commits-head mailing list
References: <4EA6EA6F.1020602@panasas.com> <20111025134800.4da48376@tpl.lwn.net>
In-Reply-To: <20111025134800.4da48376@tpl.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 09:48 PM, Jonathan Corbet wrote:
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

So what is the final disposition on git-commits-head@vger.kernel.org?
Was it decided not to have it anymore? or was it just forgotten?

If it was decided to not use it anymore. Would it help to protest?
But if it is really gone, It be best to remove the mailing list and
it's reference from: http://vger.kernel.org/vger-lists.html

It has been an important tool in the past. I'm sorry to see it go.

Thanks
Boaz
