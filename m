Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab2ENQTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:19:02 -0400
Received: from mail2.unitix.de ([176.9.2.175]:41498 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab2ENQTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:19:00 -0400
Message-ID: <4FB12FE1.2070909@arndnet.de>
Date: Mon, 14 May 2012 18:16:33 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: dave@jikos.cz
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.4.0-rc6: WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xae/0xc0
 [btrfs]()
References: <4FB10636.2010003@arndnet.de> <20120514150509.GJ25501@twin.jikos.cz>
In-Reply-To: <20120514150509.GJ25501@twin.jikos.cz>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Am 14.05.2012 17:05, schrieb David Sterba:
> On Mon, May 14, 2012 at 03:18:46PM +0200, Arnd Hannemann wrote:
>> I just got the following warning on a compressed btrfs filesystem, while writing on it
>> until no remaining space was available.
>> Looks like a bit verbose "disk full" message, is it expected behavior?
> 
> Shouldn't be the case for regular ENOSPC (ie. when the space is reserved
> in advance and with the possibility to fail early). If the transaction
> is aborted, it means it's too late and there was some logic error.
> 
> Can you please describe more the fs and how did you fill it? Like single
> process or multiple, dd or whatever.

the particular filesystem is used for chroots (/opt/chroots). It got full while
installing texlive-extra on a debian squeeze (i386) chroot.
It was probably a single process, but it involed a lot of small files.

Best regards
Arnd

