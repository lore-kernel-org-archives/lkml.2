Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0HTTET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:04:19 -0400
Received: from SMTP01.SRV.CS.CMU.EDU ([128.2.217.196]:39096 "EHLO
	smtp01.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0HTTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:04:17 -0400
Message-ID: <4C6ED15E.3050506@cs.cmu.edu>
Date: Fri, 20 Aug 2010 15:02:54 -0400
From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1 oopses at boot time in kobject allocation
References: <4C6D9289.4000702@cs.cmu.edu>	<20100819203435.GA28508@suse.de>	<4C6E799A.7060902@cs.cmu.edu> <AANLkTikkiD7qfHqkMSq3id=ap6V6gvsddca+tc8Q+bk0@mail.gmail.com>
In-Reply-To: <AANLkTikkiD7qfHqkMSq3id=ap6V6gvsddca+tc8Q+bk0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei wrote:
> 2010/8/20 Benjamin Gilbert <bgilbert@cs.cmu.edu>:
>> commit f8a4bd3456b988fc73b2c291b9e01b434c8fa940
>> Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Date:   Fri Jun 4 00:54:43 2010 -0700
>>
>>    firmware loader: embed device into firmware_priv structure
> 
> This commit does introduce one possible double free, maybe is related with
> the issue, please try the attachment patch to see if the oops can be fixed.

The patch fixes it for me.  Thanks.

--Benjamin Gilbert

