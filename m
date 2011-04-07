Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1DGVbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:31:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:54593 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1DGVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:31:18 -0400
Message-ID: <4D9E2D1C.7070102@ahsoftware.de>
Date: Thu, 07 Apr 2011 23:31:08 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexander Clouter <alex@digriz.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the
 basis of the memory size.
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <1302122121-3652-2-git-send-email-holler@ahsoftware.de> <alpine.LFD.2.00.1104061739100.28032@xanadu.home> <4D9CED15.2010806@ahsoftware.de> <alpine.LFD.2.00.1104061850410.28032@xanadu.home> <4D9CF5B3.9020007@ahsoftware.de> <toa078-0do.ln1@chipmunk.wormnet.eu>
In-Reply-To: <toa078-0do.ln1@chipmunk.wormnet.eu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.04.2011 10:55, schrieb Alexander Clouter:
> In gmane.linux.kernel Alexander Holler<holler@ahsoftware.de>  wrote:
>>
>> Sorry, I don't feel the need to waste my time prodcuing patches to get
>> them called "abominations". Which means my willingness to post further
>> patches just got below zero.
>>
> In a posting from Nico before you got offended it was explained to you
> *why* it was a Bad Idea(tm) and that that sort of thing simply does not
> work.  As a game, is it really a situation with *zero* probability of
> occuring that someone might produce a kirkwood/Sheeva flavoured board
> with only 128MB RAM?
>
> As well as a willingness to 'produce' patches (which to be frank
> *anyone* can do[1])...the hard part is producing *good* patches.  To
> produce good patches you need to read and understand the wisdom you get
> back from the mailing lists you post to.  If you do not understand the
> reasoning, ask.
>
> This is why you see [PATCHv${BIGNUM}] so often in a number of mailing
> lists.  If you are not willing to accept *everyone*, including yourself,
> writes crap code...well the value of your patches falls below zero.

Requiring a machine ID and the needed stuff to handle that for a board 
which just is using two GPIOs different than another board is why the 
ARM tree exploded. And requiring a machine ID just to follow the rule 
that a machine ID is much better than some pretty unique hw feature is 
in my humble opinion senseless and that the resulting code is more 
readable and better to maintain is a myth.

Sorry that I wanted to help there. Will not try it again.

Regards,

Alexander
