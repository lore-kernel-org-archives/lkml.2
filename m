Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1HYDHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 23:07:04 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52879 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab1HYDHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 23:07:02 -0400
X-Sasl-enc: Co0pOc6xieq718Esmb7JZI64cl3w1R1+jeurpwtpZngV 1314241621
Date: Thu, 25 Aug 2011 00:06:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Matthew Garrett <mjg@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: minor grammatical fixes to documentation
Message-ID: <20110825030654.GA6074@khazad-dum.debian.net>
References: <20110823151149.GA7495@bluemoon.ece.utexas.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823151149.GA7495@bluemoon.ece.utexas.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Kumar Appaiah wrote:
> This commit adds minor grammatical fixes to the description of the
> keys in the thinkpad-acpi documentation.
> 
> Signed-off-by: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> ---
>  Documentation/laptops/thinkpad-acpi.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
> index 6181548..b73dcea 100644
> --- a/Documentation/laptops/thinkpad-acpi.txt
> +++ b/Documentation/laptops/thinkpad-acpi.txt
> @@ -411,9 +411,9 @@ event	code	Key		Notes
>  
>  0x1004	0x03	FN+F4		Sleep button (ACPI sleep button
>  				semantics, i.e. sleep-to-RAM).
> -				It is always generate some kind
> +				It always generates some kind
>  				of event, either the hot key
> -				event or a ACPI sleep button
> +				event or an ACPI sleep button
>  				event. The firmware may
>  				refuse to generate further FN+F4
>  				key presses until a S3 or S4 ACPI

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
