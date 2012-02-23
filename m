Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2BWPEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:04:35 -0500
Received: from mail.palosanto.com ([200.93.199.101]:41023 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2BWPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:04:34 -0500
Message-ID: <4F46557B.9080901@palosanto.com>
Date: Thu, 23 Feb 2012 10:04:27 -0500
From: =?ISO-8859-1?Q?Alex_Villac=ED=ADs_Lasso?= 
	<a_villacis@palosanto.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: Fwd: Deadlock warning in 3.3-rc4 in zcache code when running
 transmission-gtk
References: <4F42F2FE.5090101@palosanto.com> <4F4515EA.2090909@palosanto.com> <4F451B02.8030201@linux.vnet.ibm.com>
In-Reply-To: <4F451B02.8030201@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 22/02/12 11:42, Seth Jennings escribió:
> On 02/22/2012 10:20 AM, Alex Villací­s Lasso wrote:
>> I am getting (potential?) deadlock warnings in zcache code shortly after
>> running transmission-gtk, the bittorrent client. My / partition is ext4,
>> and /home and /DATA (where some torrents are stored) are ext3 mounted
>> with ext4 subsystem. The warning has triggered twice so far, always
>> after running transmission-gtk.
>>
>> Fedora 16 x86_64, vanilla linux 3.3-rc4.
>> Deadlock warning did not appear in 3.3-rc3.
> This may have already been identified and fixed by this patch:
> https://lkml.org/lkml/2012/2/20/155
>
> Let me know if that doesn't fix it.
>
> --
> Seth
>
The patch indeed fixes the bug.
