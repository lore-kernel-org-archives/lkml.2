Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2BPPzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:55:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47774 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2BPPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:55:43 -0500
Date: Thu, 16 Feb 2012 15:55:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: nicolas.pitre@linaro.org, tony@atomide.com, s.hauer@pengutronix.de,
        magnus.damm@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: ARM: add xz kernel compression support
Message-ID: <20120216155507.GO13673@n2100.arm.linux.org.uk>
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 03:54:15PM +0100, Michael Opdenacker wrote:
> This patchset applies on Linus' tree
> 
> It adds xz support to the ARM tree. x86 already has it, so let's have it too!
> My benchmarks below show that xz is better than lzma in terms of image size
> and uncompression time.

Have you checked what's in my tree?  Have you checked patch 7001/2 ?
