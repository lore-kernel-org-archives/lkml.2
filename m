Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1KSNwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 08:52:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52395 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1KSNwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 08:52:53 -0500
MIME-Version: 1.0
In-Reply-To: <A5A56693-9C4C-4957-AAA5-3D1BD8AA7DCE@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
	<47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
	<alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
	<CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
	<CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
	<8343168C-D5F7-43E4-B614-45FBAF5B29A7@mit.edu>
	<A5A56693-9C4C-4957-AAA5-3D1BD8AA7DCE@mit.edu>
Date: Sat, 19 Nov 2011 22:52:52 +0900
Message-ID: <CAKYAXd99NrOC77=p31nax223UOxOONv3_JcLXUpXign8=58Vxw@mail.gmail.com>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/18 Theodore Tso <tytso@mit.edu>:
>
> On Nov 17, 2011, at 10:11 AM, Theodore Tso wrote:
>>
>> So accessing non-local memory can be a really, really big deal.  And this
>> isn't just theoretical, but have you considered what might happen on a 8
>> core AMD machine?
>
> Sorry, typo.  This should have read, "have you considered what might happen on a 8 _socket_ AMD machine"?
>
You're right. but..
It is only useful using cpuset, And have you read cpuset spread
history link of Amit provided ?
And why have you still used spread flags for inode cache ?
Thanks.

> -- Ted
>
>
