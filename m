Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1AURuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:50:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43132 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1AURuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:50:04 -0500
MIME-Version: 1.0
In-Reply-To: <20110121174055.GD15066@ghostprotocols.net>
References: <20110121163922.GA31398@davesworkthinkpad>
	<4D39BF9E.3030007@ru.mvista.com>
	<20110121174055.GD15066@ghostprotocols.net>
Date: Fri, 21 Jan 2011 17:50:03 +0000
Message-ID: <AANLkTimbh1ps7OKUE8O3gmb=FihvW-K3Av8+KiULg2Wo@mail.gmail.com>
Subject: Re: [PATCH] fix perf Annotation of Thumb code
From: David Gilbert <david.gilbert@linaro.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mingo@elte.hu,
        dave.martin@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2011 17:40, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Fri, Jan 21, 2011 at 08:17:18PM +0300, Sergei Shtylyov escreveu:
>> >(For reference this corresponds to this bug
>> >https://bugs.launchpad.net/linux-linaro/+bug/677547 )
>>
>> >        Signed-off-by: Dr. David Alan Gilbert <david.gilbert@linaro.org>
>>
>>    Hm, I think there should be no spaces/tabs before signoff...
>>
>> >+                    sym.st_value-=1;
>>
>>   The coding style used suggests spaces around -=.
>>
>> WBR, Sergei
>
> I noticed both issues and will fix them up when applying the patch.

Oops, sorry about those.  Thanks Sergei, Arnaldo.

Dave
