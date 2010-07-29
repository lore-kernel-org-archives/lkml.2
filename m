Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0G2Ub5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:31:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47641 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0G2Ubz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:31:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q2hMX7fUXYqxdTknIZUMeFC1Rhhj6XMMZO8NdjwJtE8nCGuNGmVfvwq19hXnqlY1b5
         w1wguN/i32Sq6x6R4Fd6JqFKyavjDFqj0J0tJBYV0GvFuZIlAcQIhXjsiagsJ/q2fa5g
         gi7xlbr6092vVE/NOEtDpc6P56oiVOpYt8lE0=
Message-ID: <4C51E537.9000701@gmail.com>
Date: Thu, 29 Jul 2010 22:31:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kees Cook <kees.cook@canonical.com>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <tneGvaw1wLL.A.9fB.v3XSMB@chimera> <20100723131825.GT3948@outflux.net> <201007232205.14936.rjw@sisk.pl>
In-Reply-To: <201007232205.14936.rjw@sisk.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 10:05 PM, Rafael J. Wysocki wrote:
> On Friday, July 23, 2010, Kees Cook wrote:
>> On Fri, Jul 23, 2010 at 01:47:30PM +0200, Rafael J. Wysocki wrote:
>>> This message has been generated automatically as a part of a summary report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.34.  Please verify if it still should be listed and let the tracking team
>>> know (either way).
>>
>> The regression still exists[1] in the mainline kernel -- the confirmed fix
>> mentioned below has not been committed.
> 
> That's why the bug entry hasn't been closed yet. :-)

Finally, it's merged as e7b96f28c...

regards,
-- 
js
