Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1LTABU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:01:20 -0500
Received: from void.printf.net ([89.145.121.20]:50856 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1LTABS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:01:18 -0500
From: Chris Ball <cjb@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Udo Steinberg <udo@hypervisor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: PCI suspend warnings in 3.2-rc6
References: <20111218151101.083bc530@x220.fritz.box>
	<201112190038.35760.rjw@sisk.pl>
Date: Mon, 19 Dec 2011 19:01:03 -0500
In-Reply-To: <201112190038.35760.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 19 Dec 2011 00:38:35 +0100")
Message-ID: <m28vm85cxs.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 18 2011, Rafael J. Wysocki wrote:
> On Sunday, December 18, 2011, Udo Steinberg wrote:
>> When suspending to RAM, I'm getting a bunch of warnings from the PCI layer
>> in Linux-3.2-rc6, which I didn't get with Linux-3.1. Please let me know if
>> I should provide more information about platform, config, etc.
>
> This is a known issue with sdhci-pci and there's a patch fixing that,
> hopefully in the maintainer's tree waiting for the next merge window

I'll push this for 3.2, thanks.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
