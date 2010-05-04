Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0EDXr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:47:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:3102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0EDXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jXFSQ6T/etuKiFBR08qHI5fB9ZsdfZ/wmxiO6dPFfA6cc+oT+iZrSfUN8+EYWr8lYH
         csfVKonfWTz+c/lzp5kMtbzOJuBh36BcINciEJeTHFH79GJ7YwuBE+wTT5OaCmG3Mwk/
         gKLJLWaXxMLZnv6vRLSQkgXH32BJRBarhzKPM=
Message-ID: <4BE0B225.2080308@gmail.com>
Date: Tue, 04 May 2010 15:47:49 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10pre) Gecko/20100501 Shredder/3.0.5pre
MIME-Version: 1.0
To: Andi Kleen <andi@halobates.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Bcache: version 4
References: <20100501001212.GA31135@moria> <87y6g03rf8.fsf@basil.nowhere.org>
In-Reply-To: <87y6g03rf8.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 02:14 AM, Andi Kleen wrote:
> I read all of this email now and I still have no clue what exactly
> a 'bcache' is and why anyone would want one (and if one needs
> a large stick to handle it or not)
>
> Normally the 0/x series of a patch kit is supposed to contain that
> information.
>
> I know it's probably obvious to you, but it's not to most other readers.
>
> Consider adding some introduction?

Ah, whoops. "Block cache" - it uses one block device to cache another, 
it's intended for SSDs. It's summarized decently in the documentation 
patch, which if I'd thought harder would've been the first email...
http://thread.gmane.org/gmane.linux.kernel/979977
Second patch also has relevant commentary:
http://thread.gmane.org/gmane.linux.kernel/979978
http://thread.gmane.org/gmane.linux.kernel/979979

Currently all the necessary functionality for read only is close to 
done, I'm now doing stress testing. I'm hoping to have it Stable For Me 
and read/write done in a week or two, at which point it should be ready 
for people to start playing with.
