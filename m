Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab2KZQ5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:57:55 -0500
Received: from void.printf.net ([89.145.121.20]:38514 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab2KZQ5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:57:54 -0500
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
	<m21uxu2k96.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107131157440.3174@lazy>
	<m2wrfm1537.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107181535250.1677@lazy>
	<m2zkkbb9vn.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107181546100.1677@lazy>
	<87obiqa39h.fsf@octavius.laptop.org>
	<alpine.DEB.2.02.1211261041500.3502@lazy>
Date: Mon, 26 Nov 2012 11:57:43 -0500
In-Reply-To: <alpine.DEB.2.02.1211261041500.3502@lazy> (Manoj Iyer's message
	of "Mon, 26 Nov 2012 10:42:55 -0600 (CST)")
Message-ID: <87boek9u9k.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

On Mon, Nov 26 2012, Manoj Iyer wrote:
> Do you know what systems produce these errors? I can look and see if
> we have those for testing your patch.

One T430s using the ExpressCard reader¹, and one X220, both with :e823.

Thanks,

- Chris.

¹: http://support.lenovo.com/en_US/product-and-parts/detail.page?&DocID=PD023556
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
