Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2FDQeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:34:11 -0400
Received: from natasha.panasas.com ([67.152.220.90]:42372 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2FDQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:34:09 -0400
Message-ID: <4FCCE1D4.7080805@panasas.com>
Date: Mon, 4 Jun 2012 19:27:00 +0300
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
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-14-git-send-email-jslaby@suse.cz> <4FCCA3A6.8080608@nod.at> <4FCCD224.1020307@suse.cz> <4FCCD44A.3090500@nod.at> <4FCCD70D.5010908@suse.cz> <4FCCD774.5040003@nod.at>
In-Reply-To: <4FCCD774.5040003@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:42 PM, Richard Weinberger wrote:

> Am 04.06.2012 17:41, schrieb Jiri Slaby:
>> Hmm, I remember. I suggest you to split the patch into several pieces.
>> For example moving the code from ->open into ->install can be done
>> separately. Otherwise it's hard to tell what's wrong with the patch as
>> a whole.
>>
>> Also, it would be good to see the patch rebased on the top of my
>> patch, because tty_port_set/get pieces would be gone from your patch too.
> 
> Okay, I'll redo it!
> I've a much cleaner version in my local queue.
> 


Can you send it my way, I'm still running broken, 3.4 Based ?

Thanks very much in advance
Boaz

> Thanks,
> //richard
> 
> 
> 
> 
> 
> ------------------------------------------------------------------------------
> Live Security Virtual Conference
> Exclusive live event will cover all the ways today's security and 
> threat landscape has changed and how IT managers can respond. Discussions 
> will include endpoint security, mobile security and the latest in malware 
> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
> 
> 
> 
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel


