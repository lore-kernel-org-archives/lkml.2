Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164Ab0KPKEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:04:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35594 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab0KPKEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:04:33 -0500
Date: Tue, 16 Nov 2010 10:04:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/20] ARM: LPAE: Factor out 2-level page table
	definitions into separate files
Message-ID: <20101116100406.GB12891@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-3-git-send-email-catalin.marinas@arm.com> <20101115233129.GG31421@n2100.arm.linux.org.uk> <AANLkTikrz+yM6idm-aij10vsKZMVSOBfZSdeEJbDRwiC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikrz+yM6idm-aij10vsKZMVSOBfZSdeEJbDRwiC@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 09:14:52AM +0000, Catalin Marinas wrote:
> > Of couse, I now have patches for this and my other points... will sort
> > them out into a series in the next few days.
> 
> Thanks.

BTW, don't post another round of patches just because you've had _some_
comments back - your v2 patches are still being looked through, your v3
patches haven't even been looked at yet.

It took some 4 hours for the mailing list to get through last nights
posting frenzy that it really isn't worth overloading - is it really
worth bringing the list server to its knees when the job is only half
done?
