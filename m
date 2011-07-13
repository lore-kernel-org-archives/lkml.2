Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1GMQz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:55:26 -0400
Received: from void.printf.net ([89.145.121.20]:51373 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab1GMQzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:55:24 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
	<m2sjqa2q93.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107131031360.3174@lazy>
	<201107131835.25217.arnd@arndb.de>
	<alpine.DEB.2.02.1107131144250.3174@lazy>
Date: Wed, 13 Jul 2011 12:55:17 -0400
In-Reply-To: <alpine.DEB.2.02.1107131144250.3174@lazy> (Manoj Iyer's message
	of "Wed, 13 Jul 2011 11:46:27 -0500 (CDT)")
Message-ID: <m21uxu2k96.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 13 2011, Manoj Iyer wrote:
> Do you think that lowering the controller speed to 50Mhz in case we
> have a failure is a better idea than reducing the speed for all e823
> ricoh controllers? I can send a V2 of the patch. What do you think ?

It could be better.  Do you think you could get hold of a UHS-1 card for
testing with?  (I don't think it's worth doing if there's no appreciable
performance difference either way.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
