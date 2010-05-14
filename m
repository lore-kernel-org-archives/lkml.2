Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0ENEzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:55:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab0ENEzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=p1Y4TSGXAxCWtl1m2axVPmeScS3UUUJfIxvLwDFt1ffLrjydt/KAgIeRy+CYoCjb6M
         5kj5yDkkbG5Aqt+jGd7pq9taS8+rJptxrhpYYQtbXRY5JZg64WyRCTWtAPk4I2f/kjgl
         17gNn2bcOJf9TWEAJDzLmESL1kboj8pn0k6sg=
MIME-Version: 1.0
In-Reply-To: <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
References: <4BEC7A84.3010503@gmail.com>
	 <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
Date: Fri, 14 May 2010 07:55:37 +0300
X-Google-Sender-Auth: 2516PaLVnr5hFqB81ulk7vfqXuU
Message-ID: <AANLkTim7fnKebMoEu1DjD3S-15ZqlTUez3Lpp0wGVJQ6@mail.gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Fri, May 14, 2010 at 2:01 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> not sure what this is, but while at a convention
>> I was trying to access the internet and(below is
>> full dmesg) this showed up.
>>
>> After receiving this, I sat and tried to re-create
>> my steps to reproduce but had no luck(was even going
>> todo a bisect n the spot if I could re-create).
>
> OK this stuff is hard to reproduce it seems.. you have an Atheros
> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
> to get the poison stuff? I am just surprised we haven't seen it
> ourselves yet. Let me make sure all of us get this kconfig option
> enabled.

CONFIG_SLUB_DEBUG and then either CONFIG_SLUB_DEBUG_ON or pass
'slub_debug' as kernel parameter.
