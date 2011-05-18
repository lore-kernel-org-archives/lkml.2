Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1ERLZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:25:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38907 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab1ERLZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:25:04 -0400
Date: Wed, 18 May 2011 12:24:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: anish singh <anish198519851985@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, lethal@linux-sh.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] trivial: Changed the printk loglevel when not able
	to allocate memory
Message-ID: <20110518112436.GH5913@n2100.arm.linux.org.uk>
References: <1305653342.2182.15.camel@anish-desktop> <BANLkTi=AGbuU-jyhqaSF+yXA3qQuKVLWfA@mail.gmail.com> <BANLkTi=ngJiMyVt4AMqcWUSUM2EVXtjRQQ@mail.gmail.com> <1305713710.11468.39.camel@e102109-lin.cambridge.arm.com> <BANLkTinZ6d1=58Y0SCL72Jh3F6R8yfqE-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinZ6d1=58Y0SCL72Jh3F6R8yfqE-Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 04:27:47PM +0530, anish singh wrote:
> Got it.So should i change both as KERN_WARN and resend?

Much better would be to change it to pr_warn() or even
dev_warn(&dev->dev, ...).
