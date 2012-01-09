Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab2AIUez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:34:55 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:54882 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064Ab2AIUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:34:53 -0500
Message-ID: <4F0B4F66.8000302@linux.vnet.ibm.com>
Date: Mon, 09 Jan 2012 18:34:46 -0200
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: Re: [PATCH] Updated TTY MAINTAINERS info
References: <1326137964-10671-1-git-send-email-lucaskt@linux.vnet.ibm.com> <20120109200751.GA8337@suse.de>
In-Reply-To: <20120109200751.GA8337@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12010920-2194-0000-0000-000000A3D741
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 06:07 PM, Greg KH wrote:
> On Mon, Jan 09, 2012 at 05:39:24PM -0200, Lucas Kannebley Tavares wrote:
>> Greg Kroah-Hartman is the current TTY maintainer, however he wouldn't appear
>> listed as such upon running get_maintainers.pl for drivers under
>> drivers/tty/serial.
>>
>> Signed-off-by: Lucas Kannebley Tavares<lucaskt@linux.vnet.ibm.com>
>> ---
>>   MAINTAINERS |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index cc6a466..6a856df 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6641,7 +6641,7 @@ TTY LAYER
>>   M:	Greg Kroah-Hartman<gregkh@suse.de>
>>   S:	Maintained
>>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
>> -F:	drivers/tty/*
>> +F:	drivers/tty/
>
> Isn't this just a bug in the get_maintainers.pl script?  Why does this
> patch fix the problem?
>
> greg k-h
>

To quote from MAINTAINERS

 >	F: Files and directories with wildcard patterns.
 >	   A trailing slash includes all files and subdirectory files.
 >	   F:	drivers/net/	all files in and below drivers/net
 >	   F:	drivers/net/*	all files in drivers/net, but not below

In this case I believe you are the maintainer for the entire tree, or am 
I mistaken? If so, the documentation states that it shouldn't have an 
asterisk.

Lucas

