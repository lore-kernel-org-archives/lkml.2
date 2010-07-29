Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0G2Kbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab0G2Kbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:31:43 -0400
Message-ID: <4C515877.5040101@redhat.com>
Date: Thu, 29 Jul 2010 12:31:19 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Nigel Cunningham <nigel@tuxonice.net>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, dm-crypt@saout.de,
        Pedro Ribeiro <pedrib@gmail.com>, tuxonice-devel@tuxonice.net,
        Kernel development list <linux-kernel@vger.kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [dm-crypt] kcryptd oops when resuming with TuxOnIce with KDB
 oops afterwards
References: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com>	<20100729024951.GC6247@khazad-dum.debian.net> <4C50F09C.6050201@tuxonice.net>
In-Reply-To: <4C50F09C.6050201@tuxonice.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 05:08 AM, Nigel Cunningham wrote:
> On 29/07/10 12:49, Henrique de Moraes Holschuh wrote:
>> On Thu, 29 Jul 2010, Pedro Ribeiro wrote:
>>> I hit a bug when resuming with TuxOnIce. At the middle of a resume, it
>>> says Compress Read -22 and locks up. I caught the stack trace with kdb
>>> and took photos of that.
>>
>> Maybe this?
>> http://lkml.org/lkml/2010/7/28/398
> 
> I don't think so. This issue has been around for a fair while. It's just 
> impossible to reliably reproduce, and I haven't yet found the time to 
> put some serious effort into tracking down the cause and fixing it.

Is it TuxOnIce only problem?
Or there is similar report with unpatched kernel?

Milan
