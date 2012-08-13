Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2HMKTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:19:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42879 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2HMKT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:19:28 -0400
Message-ID: <5028D4AA.10301@gmail.com>
Date: Mon, 13 Aug 2012 18:19:22 +0800
From: Liu Bo <liub.liubo@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG Report] BUG: unable to handle kernel NULL pointer dereference
 at
References: <5028C4CC.9070301@gmail.com> <871ujbkt57.fsf@nemi.mork.no>
In-Reply-To: <871ujbkt57.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 06:01 PM, Bjørn Mork wrote:
> Liu Bo <liub.liubo@gmail.com> writes:
> 
>> I'm using mainline upstream 3.6.0-rc1 compiled based on Fedora-16.
>>
>> When I unplug my mobile usb card, I hit this:
>>
>> [  247.017258] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [  247.017378] IP: [<ffffffffa03bf27f>] stop_read_write_urbs+0x3f/0x90 [usb_wwan]
> 
> Thanks for reporting.  This should be fixed by
> 
>  a1028f0 usb: usb_wwan: replace release and disconnect with a port_remove hook
> 
> currently in the usb tree, and hopefully going into the next -rc
> 
> 
> 
> Bjørn
> 

okay, I'll test it later :)

Thanks for the quick fix, Bjørn.

thanks,
liubo
