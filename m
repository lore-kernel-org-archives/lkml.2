Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1DFIXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:23:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:41074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab1DFIXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:23:07 -0400
Message-ID: <4D9C22EB.7070106@suse.cz>
Date: Wed, 06 Apr 2011 10:23:07 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kbuild@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marc Singer <elf@buici.com>
Subject: Re: [PATCH 33/34] usb/lh7a40x_udc: Drop __DATE__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-34-git-send-email-mmarek@suse.cz> <20110405162512.GB11737@n2100.arm.linux.org.uk>
In-Reply-To: <20110405162512.GB11737@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.4.2011 18:25, Russell King - ARM Linux wrote:
> On Tue, Apr 05, 2011 at 04:59:20PM +0200, Michal Marek wrote:
>> The kernel already prints its build timestamp during boot, no need to
>> repeat it in random drivers and produce different object files each
>> time.
> 
> This file no longer exists.

I only tested the series on top of 2.6.38. I dropped this patch now,
sorry for the noise.

Michal
