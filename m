Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1JBSTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:19:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48591 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab1JBSTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:19:34 -0400
Message-ID: <4E88AB2C.60804@zytor.com>
Date: Sun, 02 Oct 2011 11:19:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <201110022014.27549.rjw@sisk.pl>
In-Reply-To: <201110022014.27549.rjw@sisk.pl>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2011 11:14 AM, Rafael J. Wysocki wrote:
>>
>> You probably know enough people (including myself) that would be willing
>> to sign your key over the phone.  That's part of giving yourself
>> sufficient time.
> 
> Well, then I propose that people create two new key pairs instead of
> just one and take both of them to the KS for signing.  Afterwards, one
> of them will be used for development and the other one's private key
> will be kept in a safe place (without any online access), so it can be
> used readily if the first pair is lost or compromised somehow.
> 
> Perhaps the second pair should have a longer life time.
> 

Yes, this is actually a very good practice (the long-lived key should be
a sign-only key, for what it's worth.)  I didn't propose it because I
thought it would be too much work.

What do people think?  It might be more important for people who are
physically isolated.

>>> What number of signatures on the key will be regarded as sufficient?

FWIW, the stock PGP web of trust rules require 3 signatures.

	-hpa
