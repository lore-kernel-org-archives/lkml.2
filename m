Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1HaPIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:08:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab1HaPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:08:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 00/35] Hexagon: Add support for Qualcomm Hexagon architecture
Date: Wed, 31 Aug 2011 17:08:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org>
In-Reply-To: <20110830190729.923334292@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311708.08757.arnd@arndb.de>
X-Provags-ID: V02:K0:OHe+0Xs8vB7uSfFYcS4rPTbhWxhqQrT38u6ygLUAr5w
 ipZBg0Lkrg92xbafw8nlDHhTnDy+xNyWA9QhNXwrh5fG15VtH/
 C4fNy7aZXCtAmfsy4xIDEISKWC+lG222iBkpf9ZERsKeOIMRw9
 uL8puA/tGUcHSWzMO0z4E6/uPZgTfL+emvBbokeFnnejP76/NE
 TRGuTBP2KN/7OM/fhYtaqYn0o3+JVYgmYran3+YIEfsk7GR2sK
 2Gfebo7o1coLWz0mhI9Xwyuw4Atx4a0988FBXchlRbN3/CXLQR
 +DaTI9pV9SO/N8HYvtpU0TlrwGgNcLijEO95grh2aGBINKkdc6
 4Al1iZXWZ2rFPcQQIRGg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> 
> This is the second version of the patchset to the Linux kernel to support
> the Qualcomm Hexagon architecture.  These patches have been organized like
> the last time, in a somewhat logically grouped fashion.
> 
> A summary of changes from the last patchset:
> 
> * use Kbuild method for strictly asm-generic headers
> * clean up dma sync and implement clean/invalidate
> * bitops fl*/ff* cleanup
> * added inline assembly version of atomic_add_unless
> * removed deprecated syscalls/defines
> * call __vmyield for cpu_relax and fix cpu_idle
> * clean up thread_info; use arch allocator to allow kernel stack sizes
>   smaller than page size
> * implement read_timer_counter
> * changed checksum to pull non-asm functions from generic code
> * delete module functions which already have generic equivalents
> * cleaned up IO routines
> * reduced comet_defconfig
> * remove ugly platform code

Excellent work!

I've looked through it again and noticed a few things that I had
not seen in the first round and some that you changed but that I
still think need to be changed again.

On the whole, I think this is good to go into 3.2.

	Arnd
