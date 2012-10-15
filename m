Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab2JOIrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:47:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53091 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2JOIrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:47:18 -0400
Message-ID: <507BCD79.4040304@ahsoftware.de>
Date: Mon, 15 Oct 2012 10:46:49 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jan Kara <jack@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
References: <50531629.9020107@ahsoftware.de> <20120925110206.GD28937@mwanda> <50643C4A.9010202@ahsoftware.de> <20120927151232.GA12210@quack.suse.cz> <506474E8.3030300@ahsoftware.de> <20120927200342.GB12553@quack.suse.cz> <506746EF.5070000@ahsoftware.de> <20121001091001.GA22800@quack.suse.cz> <506960AE.2000402@ahsoftware.de> <506AB426.4000407@ahsoftware.de> <507A8189.7020402@ahsoftware.de> <20121014132714.7a869932@pyramind.ukuu.org.uk>
In-Reply-To: <20121014132714.7a869932@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.10.2012 14:27, schrieb Alan Cox:
>> The people which are responsible that the chips for "consumer"-HW and
>> laptops got their (already included) ECC functionality disabled should
>> get hit with Googles (now 3y old) study on that topic all the day.
>> Leaving customers in danger by not offering them at least the
>> possibility to use ECC RAM is just stupid.
>
> For the amount of RAM in devices now days then yes probably a good idea.
> Adding to the problem is that there is an active market in fake brandname
> DIMMs.

My solution is now that I will add memtest=1 to all my own Linux systems 
which don't have ECC (unfortunatley currently almost all). That doesn't 
cost that much time at startup and will give me at least a small chance 
to spot those extremely hard to find problems.

Regards,

Alexander

