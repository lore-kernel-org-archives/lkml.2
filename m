Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0LSSos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 13:44:48 -0500
Received: from mail.lang.hm ([64.81.33.126]:45681 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab0LSSor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 13:44:47 -0500
Date: Sun, 19 Dec 2010 10:43:40 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Willy Tarreau <w@1wt.eu>
cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [ANNOUNCE] Linux 2.6.35.10 has been released
In-Reply-To: <20101219165653.GK26410@1wt.eu>
Message-ID: <alpine.DEB.2.00.1012191040410.16878@asgard.lang.hm>
References: <20101214232747.GA18757@basil.fritz.box> <877hf66929.fsf@depni.sinp.msu.ru> <20101219002146.GA11568@kroah.com> <20101219103609.GB28751@basil.fritz.box> <20101219163935.GA23359@kroah.com> <20101219165653.GK26410@1wt.eu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Dec 2010, Willy Tarreau wrote:

> On Sun, Dec 19, 2010 at 08:39:35AM -0800, Greg KH wrote:
>> On Sun, Dec 19, 2010 at 11:36:10AM +0100, Andi Kleen wrote:
>>> On Sat, Dec 18, 2010 at 04:21:46PM -0800, Greg KH wrote:
>>>>> Could you please update this tree:
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git ?
>>>>
>>>> No, the "stable" trees are not being updated anymore, they have moved to
>>>> the longterm git directory instead.
>>>
>>> It would be good if the old stable git tree for 2.6.35 was deleted to avoid
>>> confusion. Greg, what do you think?
>>
>> No, we have never deleted any of the other trees when we "stopped"
>> maintaining them, so we shouldn't delete these either.
>>
>> I need to look this week at using git notes to mark trees as unsupported
>> or supported in a way that will work well.  That should solve this issue
>> as the note could also say 'go look at the longterm kernel' as well.
>
> Once again, I think it's not too late to replace the old trees with a
> symlink to the new one (or the opposite), considering that users have
> not updated their scripts yet. Also I'm realizing it's a bit bothering
> as a user to have to change the address of the remote when tracking such
> a branch.

the bigger problem is realizing that you need to change the remote.

the old way, all the stable kernels were togeather, and new ones (of any 
branch) would show up whenever they were released.

if we (the users) now have to setup a different remote for each person who 
manages a tree, things are getting significantly more complex (and more 
fragmented)

If there is any way that all the stable and long term trees can be kept 
under the -stable location it would be great.

the next best would be to have a -longterm like stable. But if that can be 
done, it should be pretty easy to then combine it with -stable as well, 
and _far_ more convienient for the users.

David Lang
