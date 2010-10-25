Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0JYKOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:14:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:41367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab0JYKOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:14:51 -0400
Message-ID: <4CC55894.5040509@suse.de>
Date: Mon, 25 Oct 2010 15:44:44 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: CIFS is slooow, gvfs is fast
References: <20101022013544.0fdab0e0@werewolf.home>	<4CC16B1E.4060709@suse.de>	<20101023004636.1acdd81c@werewolf.home> <20101024013038.057442c0@werewolf.home>
In-Reply-To: <20101024013038.057442c0@werewolf.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 05:00 AM, J.A. Magallón wrote:
> On Sat, 23 Oct 2010 00:46:36 +0200, "J.A. Magall�n" <jamagallon@ono.com> wrote:
> 
>>
>> If you mean hardware network path (cabling, router), yes.
>> For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mount
>> point on '~/.gvfs/media on htpc'.
>>
>> And here comes the weird part. To rule out the desktop environment factor,
>> I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
>> ~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything...
>> things get reversed depending if you use a gui or commandline.
>>
>> Weird, really weird...
>>
> 
> Well, to sort things out, I did some more tests (this does not mean things
> get any closer to be clear for me at least...).
> 
> Can anybody tell me whats going here...??
> It looks just like gui tools behave just in reverse of cli, and that a plain
> smbclient is faster that cifs. I'm really confused...
> 

Could you try mounting from commandline with something like
  `mount -t cifs //server/share /mnt/point -o user=user1`
(commenting out the fstab entry) and try copying the file?


-- 
Suresh Jayaraman
