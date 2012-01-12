Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2ALR7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:59:30 -0500
Received: from que31.charter.net ([209.225.8.23]:38862 "EHLO que31.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab2ALR71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:59:27 -0500
X-Greylist: delayed 1702 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jan 2012 12:59:27 EST
X-Authority-Analysis: v=1.1 cv=rvNqJbVGdbt4egs52VbhtoJZG7AoPDG9H2iogr/sNfs=
 c=1 sm=1 a=G_b19ol1VM0A:10 a=zWbO1dCFHhEA:10 a=wPDyFdB5xvgA:10
 a=IkcTkHD0fZMA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=D19gQVrFAAAA:8
 a=sbdJ3uwBLkhsfzDn9VMA:9 a=QEXdDO2ut3YA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Jan 2012 11:20:11 -0600
From: Greg Dietsche <gregory.dietsche@cuw.edu>
To: Michal Marek <mmarek@suse.cz>
Cc: <julia@diku.dk>, <gilles.muller@lip6.fr>, <npalix.work@gmail.com>,
        <rdunlap@xenotime.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cocci@diku.dk>
Subject: Re: [RESEND 3/3] coccicheck: add parallel execution
In-Reply-To: <4EE51709.1030305@suse.cz>
References: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <1320545653-28249-4-git-send-email-Gregory.Dietsche@cuw.edu>
 <4EE51709.1030305@suse.cz>
Message-ID: <14fc89a6d23764081dc4e94490fdb8ed@farmergreg.com>
User-Agent: Roundcube Webmail/0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-11-11 02:48pm, Michal Marek wrote:
> On 6.11.2011 03:14, Gregory.Dietsche@cuw.edu wrote:
>> +		coccinelle $f>/tmp/cocci_parallel_$$_$PARALLEL_ID 2>&1 &
>
> This opens a symlink race.
>
> And this whole parallel execution should be done by make. Just have a
> generic rule for getting result from a single check, make the default
> target depend on the list of the wanted results and concatenate the
> results there. make -j will then take of parallelizing it.

Michal,
Sorry for the slow response - my mail filters weren't behaving well at 
all...

For now, lets just drop this patch. I don't have the time to fix it up.
A few months ago I did take a look at what it would mean to use make's 
-j option
and it seemed to me that doing so would require completely changing how 
the coccinelle
script works.

I would like to see my M= patch set merged though:
https://lkml.org/lkml/2011/11/5/94

Thanks,
Greg


