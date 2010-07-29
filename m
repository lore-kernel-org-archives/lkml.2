Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0G2DOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 23:14:35 -0400
Received: from tuxonice.net ([74.207.252.127]:46159 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0G2DOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 23:14:34 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2010 23:14:34 EDT
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C50F09C.6050201@tuxonice.net>
Date: Thu, 29 Jul 2010 13:08:12 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Pedro Ribeiro <pedrib@gmail.com>, tuxonice-devel@tuxonice.net,
        kgdb-bugreport@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>,
        dm-crypt@saout.de
Subject: Re: kcryptd oops when resuming with TuxOnIce with KDB oops afterwards
References: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com> <20100729024951.GC6247@khazad-dum.debian.net>
In-Reply-To: <20100729024951.GC6247@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique.

On 29/07/10 12:49, Henrique de Moraes Holschuh wrote:
> On Thu, 29 Jul 2010, Pedro Ribeiro wrote:
>> I hit a bug when resuming with TuxOnIce. At the middle of a resume, it
>> says Compress Read -22 and locks up. I caught the stack trace with kdb
>> and took photos of that.
>
> Maybe this?
> http://lkml.org/lkml/2010/7/28/398

I don't think so. This issue has been around for a fair while. It's just 
impossible to reliably reproduce, and I haven't yet found the time to 
put some serious effort into tracking down the cause and fixing it.

Regards,

Nigel
