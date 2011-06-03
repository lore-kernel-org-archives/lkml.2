Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1FCKPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:15:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:34573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab1FCKPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:15:15 -0400
Message-ID: <4DE8B449.2000008@suse.de>
Date: Fri, 03 Jun 2011 15:45:37 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@hist.no>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
References: <4DE6103E.6010100@hist.no>
In-Reply-To: <4DE6103E.6010100@hist.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc linux-cifs@vger.kernel.org]

On 06/01/2011 03:41 PM, Helge Hafting wrote:
> At work I use cifs for accessing a windows server. This has worked fine
> for a long time, up to and including Debian's 2.6.38-2.
> 
> I just installed Debians's 2.6.39-1, and had to give up on it.
> Mounting CIFS works, and I can see the files. But if I
> try to make a new file (with cp), I get a long delay.

What is the security mechanism you are using? If you seeing the problem
with ntlm, could you try using ntlmv2 and see whether the problem is
reproducible?


> In this time, anything accessing CIFS will pause, including "ls".
> CIFS eventually becomes unstuck, and I will find that my "ls" succeeded,
> but the file copy did not. The file was created, but
> with 0 size.
> 
> Trying to copy the file again results in another stall, and so on.
> 
> 
> When I mount CIFS, I get this message:
> CIFS VFS: Unexpected SMB signature
> 
> This happens with 2.6.38 as well as 2.6.39.
> 
> When writes fail in 2.6.39, I also get:
> CIFS VFS: Send error in Close = -512
> 
> Followed by:
> CIFS VFS: Server servername has not responded in 300 seconds.
> Reconnecting...
> 
> I have also seen
> CIFS VFS: Send error in Close = -512
> and
> CIFS VFS: Send error in read = -13

-- 
Suresh Jayaraman
