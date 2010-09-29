Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0I2MgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:36:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52545 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab0I2MgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZffTwg2eLBHC8Er3o639tWeH+Ay3eNClrSkI7c+MapNNXGA6GHbQiwCEXTd2ml+vRa
         RFdeTOZiQVjQxhNCr9BYFG7ZoFzFlWVjkXTB9+dRw+GAwKHiao55ggqxNGgY2wJpgySI
         NEjssXgcLpT8VUNZGlMO7s4LUS9AYFCsyXO3w=
Subject: Re: [RFC] Online firmware upgrade in non-embedded systems
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        sf-linux-drivers <linux-net-drivers@solarflare.com>
In-Reply-To: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
References: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 15:34:18 +0300
Message-ID: <1285763658.2437.112.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 18:59 +0100, Ben Hutchings wrote:
> Currently the sfc network driver is optionally combined with an MTD
> driver (CONFIG_SFC_MTD) which exposes all upgradable firmware and
> configuration partitions in flash.  This works nicely in kernels with
> MTD enabled, but since MTD is mainly used in embedded systems with
> on-board flash it is often disabled in distribution kernels and custom
> kernels alike.  This leaves users of sfc unable to upgrade firmware
> without rebuilding the kernel or booting some other distribution.  The
> lack of widespread MTD support is a regular cause of support requests.

At least Fedora does have MTD enabled. But I guess commercial
distributions like RHEL might have it disabled (but I did not check),
and I think I could guess the reason for this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

