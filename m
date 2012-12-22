Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2LVQgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:36:42 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54689 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2LVQgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:36:40 -0500
Message-ID: <50D5E194.3050503@lwfinger.net>
Date: Sat, 22 Dec 2012 10:36:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dire state of rtl driver in 3.7
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at>
In-Reply-To: <20121222150909.GA3979@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 09:09 AM, Norbert Preining wrote:
> Dear all,
>
> I have no idea who is responsible or how to continue, but the rtl driver
> is in such a dire state and it seems nobody cares. I have no reported
> several times about it, without the slightest reactions. How can it be
> that after so many years we still not be able to do wireless.
>
> Ok, here are some facts to make people happy:
> kernel 3.7.0
> rtl8192se
> AP infos:distance: 3m
> NEC Aterm WR8600N ATERM-B45459
> firmware 1.0.11

It is not that no one cares; however, your attitude does nothing to induce me to 
work on this problem. The facts are not needed "to make people happy", they are 
necessary to try to reproduce the problem. If I cannot make it happen here, then 
I cannot fix it. Also, remember that I am a volunteer. I get nothing from 
Realtek but starting code of varying quality and some sample chips. At least my 
versions do not crash your computer.

Your subject for the E-mails certainly defeats any attempt to search. There is 
no driver named "rtl".

As I told you in a previous mailing, my system shows none of the symptoms that 
you see. I have tested all 3 varieties of chips that use driver rtl8192se and I 
never get the long ping times that you reported earlier.

I have never tested forcing a reset on the chip the way you did. I am not 
surprised that bad things happen.

 From some of the material that you report, it appears that you have an 802.11n 
connection using WPA1 encryption. (More of those pesky details!) That particular 
configuration is one that I have not been using as my 802.11n router is shared 
with my spouse, and I cannot change it that easily, but I will give it a try.

Larry


