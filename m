Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab0JSXU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:20:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab0JSXU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:20:26 -0400
Date: Tue, 19 Oct 2010 16:20:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/5] BH1770GLC, SFH7770 and APDS990x als / proximity
 sensor drivers
Message-Id: <20101019162020.954cd059.akpm@linux-foundation.org>
In-Reply-To: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 10:09:43 +0300
Samu Onkalo <samu.p.onkalo@nokia.com> wrote:

> Patch set contains two drivers. One for BH1770GLC / SFH7770 chips and
> one for APDS990X chip.
> 
> Both drivers have similar sysfs based interface. Both supports
> pm_runtime and regulator frame work. There is short documentation
> for both drivers.
> 
> Unfortunately I can't promise data sheets to public access.
> 
> Changes since patch set version 3:
> 
> - acked-by added to patches 1, 3 and 5
> - Documentation clean up (extra lines removed, LUX changed to lux)
> 
> Patches 2 and 4 are not directly acked or I have missed something.
> However, all requested cleanups have been done to those patches.

That all looks quite nice.

I'll fold patch 2 into patch 1 and patch 4 into patch 3 before sending
the patches onwards - there isn't much point in separating the code
patch from the wire-it-up-to-kbuild patch.

