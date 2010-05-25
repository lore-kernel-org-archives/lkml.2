Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0EYHPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:15:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49033 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0EYHPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lG1BoSwdewpzwmxSuKsDQI7aYgO8WQB1ESQXPQBkmtgQC8fSxz215HNxmevUpYDotZ
         6/lVcM8KhBbgGnaqzHK+rPOKlWs/aPfngp72BAm7ckQMfbvaFjOyRuanNjuPXCNj61Tf
         qqse20cv4V4+VaSJPGMqzWdmgyikBt8k6hGng=
MIME-Version: 1.0
In-Reply-To: <20100511004655.30590.74584.stgit@localhost.localdomain>
References: <20100511004655.30590.74584.stgit@localhost.localdomain>
Date: Tue, 25 May 2010 00:15:12 -0700
X-Google-Sender-Auth: n-UxfD5MtVd2XPp62YxGlyorebM
Message-ID: <AANLkTinHm8ukQ3KlcrMKWvQ-QrlmBcWeVD-i99Q9Z7JL@mail.gmail.com>
Subject: Re: [stable-2.6.32 PATCH] ixgbe: backport bug fix for tx panic
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: stable@kernel.org, greg@kroah.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       Brandon <brandon@ifup.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 17:46, Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
> backporting this commit:
>
> commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f
> Author: Krishna Kumar <krkumar2@in.ibm.com>
> Date:   Wed Feb 3 13:13:10 2010 +0000
>
>    ixgbe: Fix return of invalid txq
>
>    a developer had complained of getting lots of warnings:
>
>    "eth16 selects TX queue 98, but real number of TX queues is 64"
>
>    http://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg02200.html
>
>    As there was no follow up on that bug, I am submitting this
>    patch assuming that the other return points will not return
>    invalid txq's, and also that this fixes the bug (not tested).
>
>    Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
>    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>    Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
>    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
> CC: Brandon <brandon@ifup.org>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>
>  drivers/net/ixgbe/ixgbe_main.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>

Greg - status?  Did you queue this patch for the stable release and I missed it?

-- 
Cheers,
Jeff
