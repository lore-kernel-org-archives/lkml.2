Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab1KHUvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:51:36 -0500
Received: from smtp141.dfw.emailsrvr.com ([67.192.241.141]:50915 "EHLO
	smtp141.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab1KHUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:51:35 -0500
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 15:51:35 EST
Message-ID: <4EB99452.1090204@iwl.com>
Date: Tue, 08 Nov 2011 12:42:58 -0800
From: Karl Auerbach <karl@iwl.com>
Reply-To: karl@iwl.com
Organization: InterWorking Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: Re: Kernel (3.0 and later) panic
References: <4EB83D4A.4010408@iwl.com> <20111108141014.2dfd614f@lxorguk.ukuu.org.uk>
In-Reply-To: <20111108141014.2dfd614f@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch you sent (in a separate email) works.  Several of us using the
new Soekris Net6501 will be very happy.

Thanks for taking a look at this and fixing it so quickly.

	--karl--
	Karl Auerbach

On 11/08/2011 06:10 AM, Alan Cox wrote:
> On Mon, 07 Nov 2011 12:19:22 -0800
> Karl Auerbach <karl@iwl.com> wrote:
> 
>> Versions 3.0 and later of the Linux kernel get a null pointer panic when
>> booting on a Soekris Net6501 board.
>>
>> The documentation for that board is at:
>>
>>   http://soekris.com/media/manuals/net6501_manual.pdf
>>
>> (It's an Intel Atom based board.)
> 
> And with an EG20T. Yes I see whats going on.
> 
> I think its being caused by Tomoya Morinaga's patch to handle EG20T
> nicely. If you don't have the EG20T driver in then it tries to fall back
> to 8250 but the entries are missing
> 
> 	.setup = pci_default_setup.
> 
> 
> Patch to test will follow in about 2 minutes. Please test and report back.
> 
> Alan

