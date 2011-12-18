Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1LRReA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 12:34:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58630 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1LRRdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 12:33:53 -0500
MIME-Version: 1.0
In-Reply-To: <20111217182955.GX2203@ZenIV.linux.org.uk>
References: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com>
 <20111216192320.GA23748@infradead.org> <1324071040.29432.3.camel@sasha>
 <20111216233041.GU2203@ZenIV.linux.org.uk> <87vcpfjosl.fsf@linux.vnet.ibm.com>
 <20111217182955.GX2203@ZenIV.linux.org.uk>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Sun, 18 Dec 2011 11:33:30 -0600
Message-ID: <CAFkjPTkgryXQLBvm_z6rRDzbYxZRB+jemg+wALQg8W=SQ5OcEg@mail.gmail.com>
Subject: Re: [PATCH] fs: Move attribute flags into non __KERNEL__ space
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If these aren't normally exposed to user space, then how are they
typically set?  That interface may make more sense at the protocol
level (and perhaps more so from the server side implementation).

        -eric


On Sat, Dec 17, 2011 at 12:29 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Dec 17, 2011 at 07:14:26PM +0530, Aneesh Kumar K.V wrote:
>
>> > It's a 9P bug; fix it there.  Turning random internal constants into a part
>> > of ABI is not going to work.
>>
>> I guess we would need to define them at the protocol level then.
>> Something like f88657ce3f9713a0c62101dffb0e972a979e77b9.
>
> The question is which ones make sense at the protocol level...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
