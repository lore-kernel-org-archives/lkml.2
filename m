Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0G1INN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:13:13 -0400
Received: from kz-easy.com ([85.214.25.173]:35342 "EHLO almaty.kz-easy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab0G1INK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:13:10 -0400
X-Greylist: delayed 856 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2010 04:13:10 EDT
Date: Wed, 28 Jul 2010 09:58:37 +0200
From: Baurzhan Ismagulov <ibr@radix50.net>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: JPEG hw decoder
Message-ID: <20100728075837.GA14608@radix50.net>
Mail-Followup-To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 10:42:53AM +0530, rd bairva wrote:
>       My board has a hardware JPEG decoder. I want to write a driver
> for this in Linux kernel, But it seems there that no Framework exists
> in kernel. Can somebody provide me some pointers?

http://lwn.net/Kernel/LDD3/

You'd probably want to define the application interface using open /
read / write / ioctl / poll / close and implement them in a character
device.

With kind regards,
Baurzhan.
