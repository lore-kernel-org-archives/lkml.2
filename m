Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab0JFBWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:22:36 -0400
Received: from tuxonice.net ([74.207.252.127]:50301 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0JFBWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:22:35 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CABCF58.1090903@tuxonice.net>
Date: Wed, 06 Oct 2010 12:22:32 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [PATCH 03/23] Hibernation: Swap iteration functions.
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <1285566238-10966-4-git-send-email-nigel@tuxonice.net> <20101004175457.GC1518@ucw.cz>
In-Reply-To: <20101004175457.GC1518@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 05/10/10 04:54, Pavel Machek wrote:
> On Mon 2010-09-27 15:43:38, Nigel Cunningham wrote:
>> Add the data structure 'storage_position' and routines that allow
>> a caller to iterate over swap in sector order. Note that calling
>> reset_storage_pos only resets the position. next_swapdev_block
>> must also be called to get the address of the first (and subsequent
>> sectors).
>>
>> Signed-off-by: Nigel Cunningham<nigel@tuxonice.net>
>
> Merge this with 8/23? AFAICT, this creates unused functions here only
> to move them in later patch.

Okay. I've merged a couple of the others together too. I hope to send a 
new set in a while.

Regards,

Nigel
