Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0ICC3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:29:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51016 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0ICC3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LUfl9Yi4NA0W1LKVv7716OcUszswcjkfSw/8/XgFkOz//3OaEN5gYm6QFWloieXBHG
         larRjV8TrEyV0ANLpiRUsYAoq3y0rLgXX7JGOyxdOeIy9uoWwYIhg07WBDjz1rZVsIeO
         1NQe/EROgcmvFvZIwsfnDlkCpCs5jGZxV1O+Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
	<20100902121853.e90f6c53.randy.dunlap@oracle.com>
	<AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
Date: Fri, 3 Sep 2010 03:29:41 +0100
Message-ID: <AANLkTikBOUSGYkopdUcV+5KsayRi-_88kktMLv=KXRU0@mail.gmail.com>
Subject: Re: [RFC] Fix typos
From: Phillip Lougher <phil.lougher@gmail.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 8:31 PM, Lucas De Marchi
<lucas.de.marchi@gmail.com> wrote:
> On Thu, Sep 2, 2010 at 16:18, Randy Dunlap <randy.dunlap@oracle.com> wrote:

>> I'm not so sure about "is rose up" being better.  and what about "ar"?
>
> I'm only changing words with 3 chars or more, because otherwise I
> would have a lot of false positives, but I think I can add this word
> without much trouble.
>

The problem with "ar" is it is too short to know for certain what it
should be...  "ar" though likely a typo for "are" could also be a typo
for e.g. "arm", "arc", "arg", "ark", and "arp".

Perhaps in this and similar cases the script should flag these errors
for human attention rather than automatically fixing them.

Phillip
