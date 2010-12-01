Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0LAQQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:16:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43824 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0LAQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wDazTJorH9dvHAsx4n3xK7cm39Gr+UNWESjgIazH+ysDqtiry3KFq2D0hATP9/DMEW
         xsgIBYAn2IiuekqXpbTHKZmnGrDe7f2rVm09rI5gloZqsJRFuBpgZm9IYpIrY1CwTffN
         EYbvhAZkfKtvVX3Guq8KPNGqssrIesi758NAE=
Date: Thu, 2 Dec 2010 00:19:27 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Problems using EXPORT_SYMBOL with lib/flex_array
Message-ID: <20101201161927.GC9337@hack>
References: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com> <AANLkTim=srU8kv-DwL4jgwRS-yH8WN34PgCqsijZvYeV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim=srU8kv-DwL4jgwRS-yH8WN34PgCqsijZvYeV@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 01:20:30PM +0000, Alex Bennee wrote:
>On 1 December 2010 12:05, Alex Bennee <kernel-hacker@bennee.com> wrote:
>> Hi,
>>
>> I want to be able to use the flex_array functions in my module so I
>> wanted to EXPORT_SYMBOL the API.
>> <snip>
>> Am I being a
>> little dim or is there some other magic foo that needs doing to add an
>> export to a library function?
>
>It turns out for library code there is. If the .o is only included in
>the lib-y section then it will never get scanned for exported kernel
>symbols. Tweaking the lib/Makefile so obj-y included flex_array.o did
>the trick.
>
>I'm unsure if this behaviour is what is wanted?
>

Yes, but not sure about flex_array.o.
Which functions in flex_array.c do you need in your module anyway?

-- 
Live like a child, think like the god.
 
