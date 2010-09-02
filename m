Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0IBUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:16:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55879 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab0IBUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:16:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gnEI9o49qAqogT9gSLJXtdmMs8gaTGte4O5vKgcjrNbij4sDT18Ski1Dq73qPadKl2
         1EY3aU+ewSE5qpgLNUK3nkrav/ixOuAEu6xYkHHE1YPdDLboV3AgZ+2ChNC6RYiReBM0
         96dJNJWu/RiEB1yBZz1JF6Aloy8vqj9Nup1oY=
MIME-Version: 1.0
In-Reply-To: <AANLkTineHC5C=Sv5uZezx7-RF3_rQOJFBePhfzD6jfMF@mail.gmail.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com> <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
 <4C800266.1000005@oracle.com> <AANLkTineHC5C=Sv5uZezx7-RF3_rQOJFBePhfzD6jfMF@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 2 Sep 2010 16:16:07 -0400
Message-ID: <AANLkTinz2TEgJD5XVXSgcN0Zq0cL43a9xh004etmA2=V@mail.gmail.com>
Subject: Re: [RFC] Fix typos
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 16:08, Lucas De Marchi wrote:
> On Thu, Sep 2, 2010 at 17:00, Randy Dunlap wrote:
>> It looks good for Documentation/.
>>
>> And fixing typos is certainly something that we want to do in
>> user-visible messages, like printk strings.
>
> What about comments and code?

i think it's useful to fix typos in those things, but this would def
require a human to review things.  it might also be saner to start
with a whitelist of common typos (doesnt checkpatch have this ?)
rather than doing it against a dictionary.

for example, we've committed a few drivers that used "platfrom" in
their structure names when it should have been "platform".
-mike
