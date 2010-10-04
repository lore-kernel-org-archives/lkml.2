Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0JDWBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:01:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0JDWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:01:04 -0400
Message-ID: <4CAA4E9E.8040002@suse.cz>
Date: Tue, 05 Oct 2010 00:01:02 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fix Kconfig dependencies
References: <1286199093-3576-1-git-send-email-mmarek@suse.cz> <20101004180346.59b10af7@endymion.delvare>
In-Reply-To: <20101004180346.59b10af7@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.10.2010 18:03, Jean Delvare wrote:
> You have bad luck, I'm afraid. Sure, most users do not unset
> I2C_HELPER_AUTO, so they will not see the extra entries in the main I2C
> menu, however _I_ unset it and guess what, _I_ am the one deciding
> whether your patch can be applied or not ;)

OK :).


>> Please consider for 2.6.36, as the warning is caused by a kconfig fix
>> that I'm about to send to Linus for 2.6.36. And it is triggered by a
>> simple 'make defconfig' in i386/x84_64:
> 
> You should reconsider then. Kernel 2.6.36 will be released in a few
> days, is your fix so important that it has to go in, even when you have
> evidence that it breaks other parts of the configuration, which in turn
> will have to be fixed?

To clarify: The kconfig fix does not "break" anything. It just correctly
warns in cases where it previously did not spot a broken dependency. My
patch was just a means to silence a warning, nothing more.

Michal
