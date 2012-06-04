Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2FDRVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:21:52 -0400
Received: from natasha.panasas.com ([67.152.220.90]:44045 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2FDRVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:21:51 -0400
Message-ID: <4FCCED0A.8080605@panasas.com>
Date: Mon, 4 Jun 2012 20:14:50 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <gregkh@linuxfoundation.org>, Jeff Dike <jdike@addtoit.com>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        <alan@linux.intel.com>
Subject: Re: [uml-devel] [PATCH 13/24] TTY: um/line, use tty from tty_port
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-14-git-send-email-jslaby@suse.cz> <4FCCA3A6.8080608@nod.at> <4FCCD224.1020307@suse.cz> <4FCCD44A.3090500@nod.at> <4FCCD70D.5010908@suse.cz> <4FCCD774.5040003@nod.at> <4FCCE1D4.7080805@panasas.com> <4FCCE255.4080705@nod.at> <4FCCE866.7050203@panasas.com> <4FCCEAE5.9000801@nod.at>
In-Reply-To: <4FCCEAE5.9000801@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 08:05 PM, Richard Weinberger wrote:

> Am 04.06.2012 18:55, schrieb Boaz Harrosh:
>> No still crashing the same, way. BTW I do not have a systemd Distro. It's
>> plain old FC12. Though in the lab I have the same crash with FC15.
>>
>> The crash is immediately after I login at the initial prompt. (every time)
> 
> Okay, I'll test my patches with FC12 too. :-\
> 


Thanks. Do you need help with an image?

>> Here is the crash print, what ever that is worth in UML.
>> (Can we make the crash dump stack trace a bit less terrible?)
> 
> -ENOPATCH. :-)
> Feel free to send one.
> 


:-) It's always the: "how much time I spend on saving time later?"

But I promise I'll do it one day.

> Thanks,
> //richard
> 
> 


Thanks
Boaz
