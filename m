Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1H3S0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:26:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62028 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1H3S0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:26:41 -0400
Message-ID: <4E5D2B5D.2070800@gmail.com>
Date: Tue, 30 Aug 2011 20:26:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Vishnupradeep <intermedia.vishnu@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] linux-3.0.4 compile error on file arch/x86/include/asm/unistd_64.h
References: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com> <4E5C8EA3.7060304@gmail.com> <CACk0-C8E2uaB-Ben5K0e7dzC9RC_WDoXx8mV4B-PN4LPYGs92g@mail.gmail.com> <20110830181639.GB24865@kroah.com>
In-Reply-To: <20110830181639.GB24865@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 08:16 PM, Greg KH wrote:
> On Tue, Aug 30, 2011 at 11:37:33PM +0530, Vishnupradeep wrote:
>> Yes, i am sure. I just downloaded from kernel.org and ran "make"
>
> That's not how to properly configure and build a kernel.  Have you read
> the documentation on how to do this?  Can you attach your .config file
> that you used and ran into this error?

Well, there is nothing like "#Define" on that line:
$ wget ftp://ftp.kernel.org/pub/linux/kernel/v3.0/linux-3.0.4.tar.bz2
...
2011-08-30 20:18:53 (8.88 MB/s) - `linux-3.0.4.tar.bz2' saved [76759291]

$ tar xf linux-3.0.4.tar.bz2
$ sed -n '668 p' linux-3.0.4/arch/x86/include/asm/unistd_64.h
#define __NR_fanotify_mark                      301




So my guess is that he has a failing memory. (Single bit flip in d->D.)

regards,
-- 
js
