Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627Ab0JGNhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:37:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760616Ab0JGNhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:37:41 -0400
Message-ID: <4CADCD24.90507@suse.cz>
Date: Thu, 07 Oct 2010 15:37:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fix Kconfig dependencies
References: <1286199093-3576-1-git-send-email-mmarek@suse.cz>	<20101004180346.59b10af7@endymion.delvare>	<20101004223020.GA14702@sepie.suse.cz>	<20101005100349.73914574@endymion.delvare>	<20101005155631.GA9399@sepie.suse.cz> <20101007152442.1901a630@endymion.delvare>
In-Reply-To: <20101007152442.1901a630@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.10.2010 15:24, Jean Delvare wrote:
> OK, I've applied this patch. I doubt I can get it in Linus' tree before
> 2.6.36 is release though, my previous pull request wasn't even
> acknowledged yet.

OK, thanks.


> Then we will have to discuss about a better solution with Roman Zippel,
> because what we have now is all but elegant. Will you start the
> discussion, or should I?

Roman has been absent for a year and half :(. The closest thing to a
kconfig maintainer is currently me...

Michal
