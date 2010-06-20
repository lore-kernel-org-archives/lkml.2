Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0FTHvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 03:51:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32833 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab0FTHvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 03:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FC7hZVS1hkY5siDvx2p1t8EcAPqvPiKG8E1NuzvYdsbC6Ywr8OK2C/mg0Ys8lHFzjB
         j72Ll/VwznfmYBUa+RiWQbsCvGbl0OH3MjvJhEeWHcbCEOY9fAK7hktXNnleHLyBvamz
         kMGvX2qUhviLT3kVcqUkmCpQjvuiE75n5knBI=
Message-ID: <4C1DC883.7090009@gmail.com>
Date: Sun, 20 Jun 2010 09:51:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
CC: linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: wait_for_completion_interruptible does not wait !! [During PM
 suspend]
References: <AANLkTik5x38mWno0EUGhaHDD_INLlpeaGSExGxjIC4as@mail.gmail.com>
In-Reply-To: <AANLkTik5x38mWno0EUGhaHDD_INLlpeaGSExGxjIC4as@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2010 09:42 AM, Suresh Rajashekara wrote:
> On Sun, Jun 20, 2010 at 12:23 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 06/20/2010 08:52 AM, Suresh Rajashekara wrote:
>>> The ioctl waits on a completion variable (using
>>> wait_for_completion_interruptible).
>> ...
>>> I tried wait_for_completion instead, but now the kernel refuses to suspend.
>>
>> Do you check return value of wait_for_completion_interruptible and
>> return its value if nonzero?
>>
>> We need the code to comment, otherwise it's hard to say.
> 
> No. I am not checking the return value of the
> wait_for_completion_interruptible. I can do it

I thought so. Generally, all *_interruptible functions return a value
which should be checked and propagated to upper layers.

-- 
js
