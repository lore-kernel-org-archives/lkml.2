Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2H0Xal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:30:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46209 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab2H0Xaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:30:39 -0400
Message-ID: <503C031A.4040003@landley.net>
Date: Mon, 27 Aug 2012 18:30:34 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: liang xie <xieliang007@gmail.com>, Harry Wei <harryxiyou@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@zh-kernel.org
Subject: Re: [PATCH 1/1] Document:add Chinese translation of basic_profiling.txt
References: <CADu=CFriPHFUG8aM9h=dGsTzmRHAq1QKCu5XO9iY0ZL8-gBALg@mail.gmail.com> <503B48AA.5050605@landley.net> <20120827130201.GA9468@kroah.com>
In-Reply-To: <20120827130201.GA9468@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 08:02 AM, Greg KH wrote:
> On Mon, Aug 27, 2012 at 05:15:06AM -0500, Rob Landley wrote:
>> On 08/26/2012 11:06 AM, liang xie wrote:
>>> This is a Chinese translated version of Documentation/basic_profiling.txt
>>>
>>> Signed-off-by: Liang Xie <xieliang007@gmail.com>
>>
>> Not speaking Chinese, there's nothing useful I can say about this.
>>
>> What is the path something like this takes into the kernel? (Am I
>> expected to forward it, or I can I add an X: line to MAINTAINERS to
>> filter out my CC for this directory?)
> 
> For historical reasons, I seem to be the one handling the patches for
> these types of translated files.
> 
> I don't mind to continue to do this, unless you wish to do it?

I'm happy for you to continue handling the translation. As I said, I
can't provide any useful review here.

I have a nefarious scheme to reorganize the Documentation directory when
I get an uninterrupted block of time to work on it, at which point I
might want to collate all the translations under some kind of
Documentation/translations directory. Gotta ship a thing at work first,
though.

Thanks,

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
