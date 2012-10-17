Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2JQEu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:50:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50074 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2JQEu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:50:57 -0400
Message-ID: <507E392E.2010305@gmail.com>
Date: Tue, 16 Oct 2012 22:50:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Shane Huang <shane.huang@amd.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ata4.00: failed to get Identify Device Data, Emask 0x1
References: <20121016144932.GA24044@aftab.osrc.amd.com> <20121016155824.00d5b618@pyramind.ukuu.org.uk> <20121016151830.GB24044@aftab.osrc.amd.com> <507E0C1A.1010705@intel.com>
In-Reply-To: <507E0C1A.1010705@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 07:38 PM, Aaron Lu wrote:
> On 10/16/2012 11:18 PM, Borislav Petkov wrote:
>> On Tue, Oct 16, 2012 at 03:58:24PM +0100, Alan Cox wrote:
>>> Can you check whether 3.6 works on them. I know 3.6 is horribly broken
>>> on several brands of AHCI controller (Jmicron for example). Dunno
>>> where Jeff is on fixing the regressions ?
>>
>> If by "works" you mean I don't see the message there, then yes, it does.
>> Logs say the message started appearing on Oct 4th after me building
>> Linus master after the merge window started.
>>
>> Ok, let me test 3.6.2 just in case ...<tests>... yes, no error message
>> there.
>
> This is brought by commit: 65fe1f0f66a57380229a4ced844188103135f37b,
> ahci: implement aggressive SATA device sleep support.
>
> Shane, got time to take a look? This debug message made people
> uncomfortable :-)

I don't have whatever version of ATA command set defines this command, 
but surely there's some identify bit which lists whether this log page 
is supported. Right now checking for it is only conditional on NCQ support.
