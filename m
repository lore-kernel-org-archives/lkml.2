Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2AIRlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:41:55 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:55512 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752530Ab2AIRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:41:53 -0500
Message-ID: <4F0B348A.3070708@xenotime.net>
Date: Mon, 09 Jan 2012 10:40:10 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jon Masters <jcm@redhat.com>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
References: <1325951076.860.2.camel@mop> <871ur99vzf.fsf@rustcorp.com.au> <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com>
In-Reply-To: <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 04:44 AM, Kay Sievers wrote:
> On Mon, Jan 9, 2012 at 08:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> On Sat, 07 Jan 2012 16:44:36 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
>>> Recent tools do not use /proc to retrieve module information. A few values
>>> are currently missing from sysfs.
>>
>> Well, strace says lsmod still does.  Is libkmod doing something
>> different?
> 
> Yes, kmod used /sys only.
> 
> There is current code to read the size, to provide the 'lsmod' output,
> but that will be removed.
> 
>> Should we be deprecating /proc/modules?
> 
> In the longer run, yes.

Deprecate it for udev?  OK.
what about other users of it?

> We still aim for leaving everything that isn't process- or
> namespace-related (which, with some stretch is always process-related)
> alone, and use /sys for it.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
