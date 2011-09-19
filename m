Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1ISUom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:44:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54195 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab1ISUol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:44:41 -0400
Message-ID: <4E77A9B1.1040107@gmail.com>
Date: Mon, 19 Sep 2011 21:44:33 +0100
From: Dave Kilroy <kilroyd@googlemail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, greg@kroah.com, pe1dnn@amsat.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: Declare support for WEXT 21
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>            <1316462896-17846-4-git-send-email-kilroyd@googlemail.com> <15411.1316463771@turing-police.cc.vt.edu>
In-Reply-To: <15411.1316463771@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/2011 21:22, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 19 Sep 2011 21:08:16 BST, David Kilroy said:
>> There may be a few areas where we don't actually support WE21,
>> but by doing this it will make it easier to find those places.
>
> I'll bite - what happens when we find such a place?  Kernel fails to build, or
> user has a suboptimal usage experience, or?

The user would have a sub-optimal experience. iwconfig may not display a 
few things correctly (ESSID?) in particular scenarios.

The reason I included this patch was that I'm not sure whether 
wpa-supplicant requires WEXT version to be above a certain threshold to 
use the events in the previous patch. I'm happy to drop this one if it 
just works.

> What are the expected chances that sticking this in linux-next for a cycle will
> result in most/all of the places being found before this all appears in an
> official release?  I'm thinking this should probably go in linux-next right after
> the next merge window closes, to maximize the chances we'll shake it
> all out during almost 2 cycles before it hits the streets. (And yes, I know
> it's a staging/ driver - if somebody else says "one cycle is more than enough"
> I'm OK with that too...)

This hardware is old, and as far as I can tell quite rare. I'd hope we 
can get some feedback from Henk on the series before applying this patch.

Thanks,

Dave.
