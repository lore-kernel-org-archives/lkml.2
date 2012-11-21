Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2KUJQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:16:25 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50522 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2KUJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:16:22 -0500
Date: Wed, 21 Nov 2012 01:16:15 -0800
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Calxeda cpuidle support
Message-ID: <20121121091615.GT7615@quad.lixom.net>
References: <50AA4621.20509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AA4621.20509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 08:45:53AM -0600, Rob Herring wrote:
> Arnd, Olof,
> 
> Please pull cpuidle support for highbank. This is the first driver in
> drivers/cpuidle. All the existing drivers for ARM are in arch/arm. I'm
> asking for you to pull since there seems to be a lack of maintainer for
> cpuidle drivers.
> 
> Regards,
> Rob
> 
> The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:
> 
>   Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)
> 
> are available in the git repository at:
> 
>   git://sources.calxeda.com/kernel/linux.git tags/highbank-cpuidle

Thanks, pulled into next/soc.


-Olof
