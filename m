Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2GQMuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:50:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab2GQMum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:50:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt
Date: Tue, 17 Jul 2012 12:50:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        devicetree-discuss@lists.ozlabs.org
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz>
In-Reply-To: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207171250.32265.arnd@arndb.de>
X-Provags-ID: V02:K0:SoiX4eSbgZsb/RQfdMsufM5o9hh5nybG5rBE2aEEKeF
 tCvrHc1bv5k4XkPYy5qTfDUvnITLJx+BEOJaP7X435DAJOCe2N
 ey2qFzo+RRo/PLhvOemNjy4F3vHyzoCxLblbgaQlkRQ9ndD7iD
 BTZKrHrVFruGgy5rZbEnf+PXTaX+g0YqOl0d4MVlI4mHzgl8nQ
 qnAIKKYpsTEhLIXzrkHUWvQYzbNtGpzKNsc08Bz/+CKIPMsztk
 Mt5d+MzviP3aH9xJQ7Rsv+K9SMxc1rCFrByfnQNyyc3xN8vDsE
 cglzpHe40674v1c8+uCnWdOMEN6VLKebJLTiyeJW/lgrO6A0PS
 UwvTxDD96IOPEraLdqzw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012, Tony Prisk wrote:
> From 756ae5c2f475d679649adff99058679b651af8d9 Mon Sep 17 00:00:00 2001
> From: Tony Prisk <linux@prisktech.co.nz>
> Date: Tue, 17 Jul 2012 19:09:31 +1200
> Subject: [PATCH] Add Wondermedia Technologies (wmt) to vendor-prefixes.txt
>  Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
 
Something went wrong with exporting the patch. You probably used git-show
rather than git-format-patch, so you got the wrong headers.

It would also be helpful to describe why the specific string is used here.
Normally we use the stock ticker symbol and "wmt" refers to Wal-Mart,
which would be unlikely but not impossible to produce their own hardware
in the future. The same thing applies to "via", which is VIACOM. The symbol
for VIA technologies is "2388.TW", but that is not particularly descriptive
or well-known.

Maybe someone on the devicetree-discuss mailing list has a better
suggestion. I think using "via" is probably the best compromise, as
it's a well-known name and most of the components of the wondermedia
chips were first made by VIA anyway.

	Arnd
