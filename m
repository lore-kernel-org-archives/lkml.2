Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab1L2Fbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 00:31:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38455 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1L2Fbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 00:31:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111228140445.70c11f9c@bob.linux.org.uk>
References: <1324579605.19018.3.camel@localhost.localdomain>
	<20111228140445.70c11f9c@bob.linux.org.uk>
Date: Thu, 29 Dec 2011 11:31:35 +0600
Message-ID: <CADZ9YHhORC2N-vs3DjwXnCQCkcTEbieF4xqBxPiXskdZu7WySg@mail.gmail.com>
Subject: Re: [PATCH] staging, gma500: Fix warning in power.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 8:04 PM, Alan Cox <alan@linux.intel.com> wrote:
> On Fri, 23 Dec 2011 00:46:45 +0600
> Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>>  gma_resume_display() wants 'struct pci_dev *' as it's parameter, so
>> lets pass dev->pdev instead of dev. Fixes the following warning.
>>
>> drivers/staging/gma500/power.c: In function ‘gma_power_begin’:
>> drivers/staging/gma500/power.c:269:3: warning: passing argument 1 of
>> ‘gma_resume_display’ from incompatible pointer type
>> drivers/staging/gma500/power.c:99:13: note: expected ‘struct pci_dev
>> *’ but argument is of type ‘struct drm_device *’
>
> This staging driver is now dead and replaced with
> drivers/gpu/drm/gma500/. Thanks for the fix however
>
The patch was prepared against 3.2-rc6 and at the time of preparing
the patch that was the latest rc release.

Thanks,
Rakib
