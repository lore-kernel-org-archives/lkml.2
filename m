Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab0G2Lij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:38:39 -0400
Received: from tuxonice.net ([74.207.252.127]:55301 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab0G2Lih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:38:37 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C516839.1060909@tuxonice.net>
Date: Thu, 29 Jul 2010 21:38:33 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, dm-crypt@saout.de,
        Pedro Ribeiro <pedrib@gmail.com>, tuxonice-devel@tuxonice.net,
        Kernel development list <linux-kernel@vger.kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [dm-crypt] kcryptd oops when resuming with TuxOnIce with KDB
 oops afterwards
References: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com>	<20100729024951.GC6247@khazad-dum.debian.net> <4C50F09C.6050201@tuxonice.net> <4C515877.5040101@redhat.com>
In-Reply-To: <4C515877.5040101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 29/07/10 20:31, Milan Broz wrote:
> On 07/29/2010 05:08 AM, Nigel Cunningham wrote:
>> On 29/07/10 12:49, Henrique de Moraes Holschuh wrote:
>>> On Thu, 29 Jul 2010, Pedro Ribeiro wrote:
>>>> I hit a bug when resuming with TuxOnIce. At the middle of a resume, it
>>>> says Compress Read -22 and locks up. I caught the stack trace with kdb
>>>> and took photos of that.
>>>
>>> Maybe this?
>>> http://lkml.org/lkml/2010/7/28/398
>>
>> I don't think so. This issue has been around for a fair while. It's just
>> impossible to reliably reproduce, and I haven't yet found the time to
>> put some serious effort into tracking down the cause and fixing it.
>
> Is it TuxOnIce only problem?
> Or there is similar report with unpatched kernel?

It's TuxOnIce specific.

Regards,

Nigel
