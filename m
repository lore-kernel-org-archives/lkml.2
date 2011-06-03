Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1FCPLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:11:10 -0400
Received: from ix03.ka.hist.no ([158.38.48.167]:63993 "EHLO ix03.ka.hist.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab1FCPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:11:08 -0400
Message-ID: <4DE8F989.50208@hist.no>
Date: Fri, 03 Jun 2011 17:11:05 +0200
From: Helge Hafting <helge.hafting@hist.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Icedove/3.1.10
MIME-Version: 1.0
To: Suresh Jayaraman <sjayaraman@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
References: <4DE6103E.6010100@hist.no> <4DE8B449.2000008@suse.de>
In-Reply-To: <4DE8B449.2000008@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2011 15:11:05.0848 (UTC) FILETIME=[75CAEF80:01CC2200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03. juni 2011 12:15, Suresh Jayaraman wrote:
> [Cc linux-cifs@vger.kernel.org]
>
> On 06/01/2011 03:41 PM, Helge Hafting wrote:
>> At work I use cifs for accessing a windows server. This has worked fine
>> for a long time, up to and including Debian's 2.6.38-2.
>>
>> I just installed Debians's 2.6.39-1, and had to give up on it.
>> Mounting CIFS works, and I can see the files. But if I
>> try to make a new file (with cp), I get a long delay.
>
> What is the security mechanism you are using? If you seeing the problem
> with ntlm, could you try using ntlmv2 and see whether the problem is
> reproducible?

In the beginning, I did not specify the mechanism. So, whatever the 
default is.

The fstab entry was like this:
\\servername\resource /mountpoint cifs 
domain=MYDOMAIN,credentials=/etc/fstabcred,rw,noauto,iocharset=utf8,uid=username,gid=group,sockopt=TCP_NODELAY,users,file_mode=0640,dir_mode=0750,relatime 
0 0

I looked at cifs options, and tried to add "sign" and "sec=ntlmv2i". It 
made no difference. Still failure with 2.6.39, and mounting with these 
new options works fine with 2.6.38

Helge Hafting
