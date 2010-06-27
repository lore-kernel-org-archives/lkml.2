Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0F0S2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 14:28:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45772 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab0F0S2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 14:28:35 -0400
Message-ID: <4C279814.9030100@ru.mvista.com>
Date: Sun, 27 Jun 2010 22:27:32 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org> <4C224502.2040206@kernel.org> <4C2305A8.4070708@odi.ch> <4C24C903.1070705@kernel.org> <4C24EED2.4020300@odi.ch> <4C257CEE.2070309@gmail.com>
In-Reply-To: <4C257CEE.2070309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Robert Hancock wrote:

>> On 25.06.2010 17:19, Tejun Heo wrote:
>>> Patch attached, but please see below.

>> Cheers, I will give it a try and provide feedback if "it" happens again.

>>> Is it PATA?

>> Yes. This chipset doesn't have SATA, only PATA.

> Ahh, ok, it's not sata_nv at all then, it's pata_amd. On the same chip, 
> totally different controller though.

> PATA doesn't normally use hard-resets as a means of error recovery - 
> that would mean hitting the RESET line, which I don't think most 
> controllers can do on software command (it usually only gets asserted on 
> power up or hitting the reset button), unlike on SATA where there's a 
> defined way to trigger a COMRESET which is mostly equivalent. Also, that 
> resets both devices on the channel, unlike soft reset which is specific 
> to one device.

    PATA soft reset affects both devices too. Unless you mean ATAPI Device 
Reset command.

MBR, Sergei

