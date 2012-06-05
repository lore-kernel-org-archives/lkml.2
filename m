Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab2FELNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:13:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63854 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab2FELNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:13:48 -0400
Message-ID: <4FCDE9E8.3090504@gmail.com>
Date: Tue, 05 Jun 2012 15:13:44 +0400
From: George Shuklin <george.shuklin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120530 Thunderbird/13.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "H. Peter Anvin" <hpa@zytor.com>, Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why minor is still 8 bit?
References: <4FCC0E6D.9000206@gmail.com>   <20120604013504.GU30000@ZenIV.linux.org.uk> <4FCC3151.1040503@gmail.com>   <4FCCDE2B.3020306@schaufler-ca.com> <4FCD0591.2050504@gmail.com>   <4FCD5869.8000306@zytor.com> <4FCD5BF3.30707@gmail.com>  <1338888208.4971.30.camel@x61.thuisdomein> <4FCDD308.8070204@gmail.com> <1338889756.4971.34.camel@x61.thuisdomein>
In-Reply-To: <1338889756.4971.34.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2012 13:49, Paul Bolle wrote:
> On Tue, 2012-06-05 at 13:36 +0400, George Shuklin wrote:
>> This is a limitaiton of LMV itself. I'm talking about making those LV
>> active (visible in system). When you trying to activate too much LV, you
>> will get 'device io ctl failed' message.
> What is the exact text of that message? Where is it found (stderr,
> dmesg, ...)? Do you know what prints it (kernel, user space)? Do you run
> into this issue when trying to activate the 256th LV, or later, or
> earlier?
>
>
> Paul Bolle
>
Ooops, I was deeply wrong. Sorry, the problem was related to LVM 
behavior in 2.6.32-12-xs (XenServer kernel).

