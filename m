Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2AWNwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:52:03 -0500
Received: from void.printf.net ([89.145.121.20]:39398 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab2AWNwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:52:00 -0500
From: Chris Ball <cjb@laptop.org>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: Need pci rescan in order to get my mmc reader
References: <201201151255.41252.roucaries.bastien@gmail.com>
	<CAE2SPAb3Ozk7LHrqE_asazZ7kEogXEH=2S8D5PUprqXZK2o9Ow@mail.gmail.com>
Date: Mon, 23 Jan 2012 08:51:52 -0500
In-Reply-To: <CAE2SPAb3Ozk7LHrqE_asazZ7kEogXEH=2S8D5PUprqXZK2o9Ow@mail.gmail.com>
	(Bastien ROUCARIES's message of "Mon, 23 Jan 2012 11:28:34 +0100")
Message-ID: <m2mx9ev85j.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 23 2012, Bastien ROUCARIES wrote:
> On Sun, Jan 15, 2012 at 12:55 PM, bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
>> I am hit by the same bug than here
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/703180
>>
>> I order to get my mmc reader functionnal I need to put a mmc card
>> and do a pci rescan manualy.
>>
>> What could be done  ?
>>
>> What do you need in order to help ?
>>
>> Thanks

I'm not sure there's anything I (at the MMC layer) can do to help;
having a visible PCI device is a prerequisite for working MMC.

Have you tried a recent upstream kernel, and looked for any available
BIOS updates for your laptop?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
