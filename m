Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab1EWTeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:34:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43468 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab1EWTeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ze0GtJBsWTXDGlubknIPbkdV8eUb25FR1vgLF8tTXmjKxqCHWkIC0hGFhzIW6v6H0L
         QtEGjabhAmBwpd9EkIH4+IfgnS4NNX7DJz0CuNDhIL9dfEWF6WxVY0ZXbd+CzWW5fInP
         IojhuySCQpHBSa08licQk8jQ5o47z4POx+N7U=
MIME-Version: 1.0
In-Reply-To: <20110523190926.GA18092@kroah.com>
References: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
 <20110523120125.2d15da7e.randy.dunlap@oracle.com> <20110523190926.GA18092@kroah.com>
From: Vikram Narayanan <vikram186@gmail.com>
Date: Tue, 24 May 2011 01:03:43 +0530
Message-ID: <BANLkTimtqCYveCewyKX_f4f544XQObCLXw@mail.gmail.com>
Subject: Re: [PATCH 5/5] Documentation: update GregKH links
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:39 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, May 23, 2011 at 12:01:25PM -0700, Randy Dunlap wrote:
>> From: Vikram Narayanan <vikram186@gmail.com>
>>
>> Fixed the broken links in the SubmittingPatches file.
>>
>> Signed-off-by: Vikram Narayanan <vikram186@gmail.com>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>> ---
>>  Documentation/SubmittingPatches |    9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> --- linux-2.6.39-git6.orig/Documentation/SubmittingPatches
>> +++ linux-2.6.39-git6/Documentation/SubmittingPatches
>> @@ -714,10 +714,11 @@ Jeff Garzik, "Linux kernel patch submiss
>>    <http://linux.yyz.us/patch-format.html>
>>
>>  Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
>> -  <http://www.kroah.com/log/2005/03/31/>
>> -  <http://www.kroah.com/log/2005/07/08/>
>> -  <http://www.kroah.com/log/2005/10/19/>
>> -  <http://www.kroah.com/log/2006/01/11/>
>> +  <http://www.kroah.com/log/linux/maintainer.html>
>> +  <http://www.kroah.com/log/linux/maintainer-02.html>
>> +  <http://www.kroah.com/log/linux/maintainer-03.html>
>> +  <http://www.kroah.com/log/linux/maintainer-04.html>
>> +  <http://www.kroah.com/log/linux/maintainer-05.html>
>>
>
> I have no real objection to this, but the original links are not broken
> at all, and still work just fine for me here, don't they for you as
> well?
At the time of submission of this patch, It didn't work for me. (It
returned http://storm.he.net/cgi-bin/error404)
That's why I searched for the updated links and sent a patch.
But, It works fine now.
Now, its your wish, whether or not to use this patch :)

-
Thanks,
Vikram
