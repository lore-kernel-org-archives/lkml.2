Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab1EaUOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:14:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54333 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758348Ab1EaUOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:14:01 -0400
Message-ID: <4DE54BFF.5090508@zytor.com>
Date: Tue, 31 May 2011 13:13:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
References: <4DE3E9E7.8020008@zytor.com> <20110531194358.GA4424@elf.ucw.cz> <201105312204.02722.arnd@arndb.de>
In-Reply-To: <201105312204.02722.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 01:04 PM, Arnd Bergmann wrote:
> 
> Are you talking about just ftp://ftp.kernel.org/pub/linux/kernel/*/incr/
> or also about ftp://ftp.kernel.org/pub/linux/kernel/v2.6/patch-* and
> Changelog-*?
> 
> I can see reasons to keep the latter, but not necessarily the former.
> 

The former only.

>>
>> Usecase one is zaurus, which is just not powerful enough for git, and
>> usecase two are companies that only work with releases... ketchup is
>> very useful for both.
> 
> For usecase one, is it possible to replace the download links with
> links into http://git.kernel.org/ ?
> 
> For usecase two, why wouldn't those be able to just download the entire
> release tarball? At least, I would expect that there is no need for
> the small incremental patches in their case, only for the full
> inter-release patches.
> 

Zaurus I don't consider too important; anyone with a Zaurus is
realistically going to have a real development platform on hand.

	-hpa

