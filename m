Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0DBA2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 20:28:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714Ab0DBA2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:28:09 -0400
Date: Thu, 1 Apr 2010 17:23:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alex Deucher <alexdeucher@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780
 (was: Re: Linux 2.6.34-rc3)
In-Reply-To: <201004020120.50398.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1004011723010.3634@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <201004012346.45098.rjw@sisk.pl> <p2ka728f9f91004011507h259f758duf941b2239cfca87e@mail.gmail.com> <201004020120.50398.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Rafael J. Wysocki wrote:
> 
> Appended, with sign-offs and changelog.
> 
> ---
> Subject: PCI quirk: RS780/RS880: disable MSI completely

Hmm. Isn't this missing a

	From: Clemens Ladisch <clemens@ladisch.de>

too? Or was the original patch yours?

		Linus
