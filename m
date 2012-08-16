Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2HPQs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:48:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36242 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2HPQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:48:54 -0400
Message-ID: <502D2471.407@pobox.com>
Date: Thu, 16 Aug 2012 12:48:49 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
References: <50299142.2030504@oberhumer.com> <20120814123937.GA14756@sig21.net> <502B8FE3.7080501@oberhumer.com> <20120815144539.GA8300@sig21.net> <502C92C3.7090701@oberhumer.com> <502D100D.2030609@pobox.com> <20120816162051.GK11413@one.firstfloor.org>
In-Reply-To: <20120816162051.GK11413@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 12:20 PM, Andi Kleen wrote:
>> If you think a little bit, I bet you could come up with a solution that
>> operates at cacheline-aligned granularity, something that would be _even
>> faster_ than simply fixing the code to do aligned accesses.
>
> Cache aligned compression is unlikely to compress anything at all.
> Compression algorithms are usually by definition unaligned.

Sure it's a bitstream, but that does not imply the impossibility of 
reading data in in an word-aligned manner.

Maybe cache-aligned is ambitious, because of resultant code bloat, but 
machine-int-aligned is doable and reasonable.

	Jeff




