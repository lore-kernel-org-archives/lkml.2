Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1GLJor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:44:47 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:34669 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GLJoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:44:46 -0400
Message-ID: <4E1C1786.8040607@free-electrons.com>
Date: Tue, 12 Jul 2011 11:44:38 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Make Dell Latitude E6320 use reboot=pci
References: <1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com> <20110628174137.GA18115@srcf.ucam.org> <4E0A2D0C.6030701@free-electrons.com> <20110628200319.GA22487@srcf.ucam.org> <4E0AD550.5010700@free-electrons.com>
In-Reply-To: <4E0AD550.5010700@free-electrons.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

I've seen that you have worked on the reboot part, however the problem
is still present on this laptop with 3.0-rc7.

Do you need anything else ?

On 29/06/2011 09:33, Maxime Ripard wrote:
> On 28/06/2011 22:03, Matthew Garrett wrote:
>> On Tue, Jun 28, 2011 at 09:35:40PM +0200, Maxime Ripard wrote:
>>> On 28/06/2011 19:41, Matthew Garrett wrote:
>>>> On Tue, Jun 28, 2011 at 03:57:31PM +0200, Maxime Ripard wrote:
>>>>> The Dell Latitude E6320 doesn't reboot unless reboot=pci is set.
>>>>
>>>> On which kernel versions?
>>>
>>> All the versions from 2.6.38 to 3.0-rc5.
>>
>> Could you provide the acpidump output for the system?
>>
> 
> Sure, here it is :
> http://free-electrons.com/~maxime/pub/acpidumb-e6320.log
-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
