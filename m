Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2DGA13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:27:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56427 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2DGA12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:27:28 -0400
Date: Fri, 6 Apr 2012 17:27:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
Message-ID: <20120407002723.GA14568@kroah.com>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 05:11:22PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> While the kernel is GPLv2 individual files and modules have
> historically been allowed to be:
> 
>   * Dual BSD/GPL
>   * Dual MIT/GPL
>   * Dual MPL/GPL
> 
> This is done for several reasons but most importantly to be able to
> share between Linux and permissive licensed Operating Systems such
> as the BSDs.
> 
> You do not need to make dual licenses when licenses are compatible
> with each other, and in fact at times this can confuse developers / legal.
> This has been well documented by SFLC through their "Maintaining
> Permissive-Licensed Files in a GPL-Licensed Project: Guidelines for
> Developers" [0] which was inspired by the ambiguity of the MadWifi
> Project's Dual BSD/GPL license tradition. The list of GPL-Compatible
> licenses can be found on the FSF's website [1].
> 
> Lets help move out of the stone age and instead of extending this list
> with more permissive licenses add a simple "GPL-Compatible" tag for use by
> any GPL-Compatible licensed module. Given that vendors tend to grep existing
> drivers for what they do also change all drivers to use the simple tag but
> leave in place the old checks in case external drivers are using this. Moving
> forward GPL-Compatible modules should rely on this simple new tag instead
> of using the old tags or looking to add a new GPL-Compatible text descring
> that license.
> 
> [0] http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html
> [1] http://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
> 
> Cc: Keith Packard <keithp@keithp.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

