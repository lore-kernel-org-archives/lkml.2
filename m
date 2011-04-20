Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1DTOl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:41:28 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:4511 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1DTOl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:41:27 -0400
X-IronPort-AV: E=Sophos;i="4.64,246,1301871600"; 
   d="scan'208";a="763053097"
MIME-Version: 1.0
X-Priority: Normal
X-Mailer: AtMail PHP 5.62
Message-ID: <16117.1303310442@jupiter.eclipse.co.uk>
To: "Clemens Ladisch" <clemens@ladisch.de>, <rwhitton@iee.org>
Reply-To: rwhitton@iee.org
Content-Type: text/plain; charset="utf-8"
X-Origin: 213.121.168.130
X-Atmail-Account: rwhitton@jupiter.eclipse.co.uk
Date: Wed, 20 Apr 2011 15:40:42 +0100
Subject: Re: Background memory scrubbing
From: Robert Whitton <rwhitton@iee.org>
Cc: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Robert Whitton wrote:
> > I have a home grown module that performs background memory scrubbing
> > to eliminate single bit memory errors before they become a problem.
> > ... it is specifically targeted at the AMD64 PC architecture
> 
> Then why don't you use the memory controller's automatic background
> memory scrubbing support? Doesn't your BIOS have this option?
> 
> Regards,
> Clemens
> 

Hi,

Unfortunately in common with a large number of hardware platforms background scrubbing isn't supported in the hardware (even though ECC error correction is supported) and thus there is no BIOS option to enable it. The software solution has always been fine and the CPU load negligible as it's only necessary to complete one complete scrub every day or so. I just need to find a solution to making this work on newer Linux kernels.

Rob
