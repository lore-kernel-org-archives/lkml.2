Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650Ab1FXPjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:39:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab1FXPjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:39:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110623133740.0cdaf204@jbarnes-desktop>
References: <20110623133740.0cdaf204@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Jun 2011 08:38:07 -0700
Message-ID: <BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>
Subject: Re: [git pull] PCI fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 1:37 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Just a few minor fixes.  We have one open issue with the resource
> re-allocation code that was re-added.  Ram has a fix but I'm concerned
> it will introduce other regressions.  So at this point we have a few
> options:
>  - revert the bridge resource re-allocation code (again)
>  - hide the re-allocation code behind a new kernel option (and not
>    try=!), this would at least let us experiment with new strategies
>    and PNP resource tracking etc
>  - apply Ram's patch and revert it all later if things are still broken

I think I've missed the regression discussion, so can you forward a
description and the fix?

I have to admit that I'm inclined to try the fix if it's clean, just
in the hope to get over this finally. But I'd like to see  what the
problem/fix is...

Maybe I've seen it and just didn't react.

            Linus
