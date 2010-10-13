Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0JMX7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:59:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60097 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab0JMX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:59:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hPlxwwejM+RSStl5ZrpW3rztipWRS5uE32dUkDxuPNirDrKn0zKrYpN2M/baPMVY7r
         z0HSaSTxrpYdxYG2jAez6ZB9BuhCp45umFBgTm8RVGab02dtFjCntZXxmt3jT3n1lhq2
         Z8KLxgTBq1s/mJpf+aOjvk3qiQmOSowvVmHdg=
Subject: Re: [PATCH 2/2] ieee1394: remove the old IEEE 1394 driver stack
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3d7c94e2ecb3a995@s5r6.in-berlin.de>
References: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>
	 <tkrat.3d7c94e2ecb3a995@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 01:59:22 +0200
Message-ID: <1287014362.23588.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-10 at 00:12 +0200, Stefan Richter wrote:
> The drivers
>   - ohci1394 (controller driver)
>   - ieee1394 (core)
>   - dv1394, raw1394, video1394 (userspace ABI)
>   - eth1394, sbp2 (protocol drivers)
> are replaced by
>   - firewire-ohci (controller driver)
>   - firewire-core (core and userspace ABI)
>   - firewire-net, firewire-sbp2 (protocol drivers)
> which are more featureful, better performing, and more secure than the older
> drivers; all with a smaller and more modern code base.
But new stack doesn't have working networking support...

Best regards,
	Maxim Levitsky


