Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0LFP1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:27:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFP1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H2FtyiMeFBxX7py39f+XOo7oBDj64s/yt0MDXl4Z5N9sJ5ldt8wgkWM9HQxmRv7qgQ
         owSYj2WlrDGgJq9bw46NHmaMw9yvQjer/C6L/bMTG3pRk4K14XJ7ycC1RbfwJcUlNY95
         bhFg3cEtiIsUSW7X4OD4Dgb+nWDIJ6Amk6gK8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=pLjqbK8cnn0PQvFjwcUeujJS7zbHpTfO1mOiE@mail.gmail.com>
References: <20100609214616.GA31340@x200>
	<AANLkTimDVdQ6-GxMdYHznp1SZp_=_486_Vrun0JEMDw4@mail.gmail.com>
	<AANLkTi=pLjqbK8cnn0PQvFjwcUeujJS7zbHpTfO1mOiE@mail.gmail.com>
Date: Mon, 6 Dec 2010 13:27:21 -0200
Message-ID: <AANLkTinQ5gLNrUQUxeV6SzfoU7J3UcERMtmzyS2inv8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] kstrto*: converting strings to integers done
 (hopefully) right
From: Thiago Farina <tfransosi@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 1:19 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Mon, Dec 6, 2010 at 3:26 AM, Thiago Farina <tfransosi@gmail.com> wrote:
>> On Wed, Jun 9, 2010 at 6:46 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>> diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
>>> new file mode 100644
>>> index 0000000..56fda26
>>> --- /dev/null
>>> +++ b/lib/test-kstrtox.c
>>> @@ -0,0 +1,356 @@
>>> +#include <linux/init.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +
>>> +#define for_each_test(i, test) \
>>> +       for (i = 0; i < sizeof(test) / sizeof(test[0]); i++)
>>> +
>> micronit: Can you use ARRAY_SIZE macro here? Ignore this if it's irrelevant.
>
> Dunno,
> sizeof(x)/sizeof(x[0]) is really C idiom.
I know.

> And ARRAY_SIZE is misnamed, it doesn't reflect size.
>
What it reflects so? Isn't the number of elements in the array? What
would be a better name?
