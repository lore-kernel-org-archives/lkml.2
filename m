Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2E0Mem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 08:34:42 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4369 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab2E0Mel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 08:34:41 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4FC21F57.8030507@broadcom.com>
Date: Sun, 27 May 2012 14:34:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Denis Lotarev" <dlotarev@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Hibernate not working on laptop LENOVO X120e
References: <1338089209.85717.YahooMailClassic@web162605.mail.bf1.yahoo.com>
In-Reply-To: <1338089209.85717.YahooMailClassic@web162605.mail.bf1.yahoo.com>
X-Enigmail-Version: 1.5pre
X-WSS-ID: 63DCC00355G2036293-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2012 05:26 AM, Denis Lotarev wrote:
> Hello!
> My system on Lenovo X120e doesnt hibernate, when i trying to hibernate system power led begin often blinking (about 3 times at second), LCD turned off, HDD still working, and CPU fan workinkg too. There are no kernel log at messages, even if i run DEBUG=1 at pm-hibernate there are no errors at pm-hibernate.log. Suspent on RAM working good.
> Linux lenarch 3.3.7-1-ARCH #1 SMP PREEMPT Mon May 21 22:39:59 UTC 2012 i686 GNU/Linux
>  

Could you try:

# echo reboot > /sys/power/disk
# echo disk > /sys/power/state

and provide the kernel log.

Gr. AvS

