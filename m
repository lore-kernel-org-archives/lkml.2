Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1JWNWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 09:22:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58051 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1JWNWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 09:22:44 -0400
Message-ID: <4EA4151A.4030605@zytor.com>
Date: Sun, 23 Oct 2011 15:22:34 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Piotr Hosowicz <piotr@hosowicz.com>, linux-kernel@vger.kernel.org,
        John Hawley <warthog19@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.0.7 now on kernel.org
References: <20111023083131.GA13802@kroah.com> <4EA40795.3070603@example.com> <20111023122927.GB25711@kroah.com>
In-Reply-To: <20111023122927.GB25711@kroah.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 02:29 PM, Greg KH wrote:
> On Sun, Oct 23, 2011 at 02:24:53PM +0200, Piotr Hosowicz wrote:
>> On 23.10.2011 10:31, Greg KH wrote:
>>
>>> You will note that the files are signed with my new kernel release
>>> signing key, and that the .tar file is signed, and then compressed, so
>>> there is not signatures for the individual compressed files.
>>
>> And why is that? It's less handy.
> 
> I'll let hpa answer that one, he changed it for a good reason that I
> can't recall at the moment :)
> 
> hpa?
> 

Signing the compressed file makes the compression "precious".  It also
means that the developer has to sign each.

It's not significantly "more handy" either... you can do something like:

	xz -cd file.xz | gpg --verify file.sign -

	-hpa

