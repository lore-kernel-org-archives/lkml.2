Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2JAVQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:16:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50380 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2JAVQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:16:15 -0400
Message-ID: <506A0809.704@zytor.com>
Date: Mon, 01 Oct 2012 14:15:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        fengguang.wu@intel.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate the User API from the kernel headers
References: <15670.1349125526@warthog.procyon.org.uk>
In-Reply-To: <15670.1349125526@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 02:05 PM, David Howells wrote:
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Acked-by: Dave Jones <davej@redhat.com>
> Requested-by: H. Peter Anvin <hpa@zytor.com>

FWIW, I did not have time to review this before the merge window, but:

Acked-by: H. Peter Anvin <hpa@zytor.com>

I believe this will reduce the number of mishaps we have with what bits
are exported as ABI and which ones aren't, and provide a much better
platform for further improvements.

	-hpa

