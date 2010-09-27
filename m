Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0I0LjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:39:18 -0400
Received: from tuxonice.net ([74.207.252.127]:48811 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab0I0LjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:39:17 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CA08262.7090707@tuxonice.net>
Date: Mon, 27 Sep 2010 21:39:14 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Andrey Rahmatullin <wrar@altlinux.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Swsusp patches applied to suspend-2.6#linux-next
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <20100927080000.GA7032@wrars-comp.wrarsdomain> <4CA055EF.6050608@tuxonice.net> <20100927111631.GA6759@wrars-comp.wrarsdomain>
In-Reply-To: <20100927111631.GA6759@wrars-comp.wrarsdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 27/09/10 21:16, Andrey Rahmatullin wrote:
> On Mon, Sep 27, 2010 at 06:29:35PM +1000, Nigel Cunningham wrote:
>>>> On my laptop, single-threaded compression actually slows writing down from
>>>> 175MB/s to around 100-120MB/s (depending on how well the image compresses).
>>>> Reading speed improves from 218MB/s to around 245MB/s. I expect that
>>>> multithreaded writing would bring the writing (and reading) speeds back
>>>> up. It's on my swsusp to do list :)
>>> Works here.
>> What sort of speeds are you seeing?
> [  343.549378] PM: Image written at 107 MB/s.
> [  343.549379] PM: Image read at 205 MB/s.
> Latest ToI (on .35; with the lzo compressor; no clue about
> multithreadedness, though there are 4 CPUs here): I/O speed: Write 166
> MB/s, Read 192 MB/s.

Cool. Thanks!

Nigel
