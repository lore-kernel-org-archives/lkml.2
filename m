Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab0I0J5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:57:45 -0400
Received: from tuxonice.net ([74.207.252.127]:51873 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362Ab0I0J5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:57:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CA06A95.7040303@tuxonice.net>
Date: Mon, 27 Sep 2010 19:57:41 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Andrey Rahmatullin <wrar@altlinux.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Swsusp patches applied to suspend-2.6#linux-next
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <20100927080000.GA7032@wrars-comp.wrarsdomain> <4CA055EF.6050608@tuxonice.net> <20100927093826.GA6904@wrars-comp.wrarsdomain>
In-Reply-To: <20100927093826.GA6904@wrars-comp.wrarsdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 27/09/10 19:38, Andrey Rahmatullin wrote:
> On Mon, Sep 27, 2010 at 06:29:35PM +1000, Nigel Cunningham wrote:
>>>> As discussed, here are the patches, modified to apply against your current
>>>> linux-next tree. A new first patch splits compression support out into its
>>>> own file, removing the need to have two versions of the load_image and
>>>> save_image routines, minimising the changes to the remainder of the
>>>> patches and making things cleaner than would otherwise be the case.
>>>>
>>>> On my laptop, single-threaded compression actually slows writing down from
>>>> 175MB/s to around 100-120MB/s (depending on how well the image compresses).
>>>> Reading speed improves from 218MB/s to around 245MB/s. I expect that
>>>> multithreaded writing would bring the writing (and reading) speeds back
>>>> up. It's on my swsusp to do list :)
>>> Works here.
>>
>> Ah. You're too fast for me :)
>>
>> What sort of speeds are you seeing?
> Well, I don't see any 'PM: Image read at' etc in the kernel logs after
> resuming (in for-rafael tree).

You need CONFIG_PM_DEBUG enabled for that. Perhaps I should remove that 
requirement.

Nigel
