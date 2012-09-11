Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2IKHwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:52:41 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:65509 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2IKHwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:52:40 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2012 03:52:39 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0DAETqTlBbdWObgWdsb2JhbABFhUCtboghIgEBFiYngiEBBTIBBR0jARALIRYPCQMCAQIBRQYNAQcBAYgQvBeRNgOVXZMFgWE
X-IronPort-AV: E=Sophos;i="4.80,403,1344204000"; 
   d="scan'208";a="564323778"
Message-ID: <504EEB7C.3060804@igalia.com>
Date: Tue, 11 Sep 2012 09:42:52 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Samuel_Iglesias_Gons=E1lvez?= <siglesias@igalia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/20] Staging: ipack/bridges/tpci200: Put the TPCI200
 control registers into a struct.
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com> <20120910182941.GA25400@kroah.com> <1347346908.4539.70.camel@fourier.local.igalia.com>
In-Reply-To: <1347346908.4539.70.camel@fourier.local.igalia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>[...]
>
> I don't see the base64. However, I will try to figure out how can I fix
> this issue in git-send-email.

I've received them in base64 as well.

But it also happened to me before that round of patches was encoded in 
base64 using format-patch and send-email, instead of using utf8, with no 
apparent reason, and just recreating the patches and resending them 
fixed the encoding to 8 bits.

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com
