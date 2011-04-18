Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1DRGzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 02:55:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1DRGz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 02:55:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V14 1/4] ptp: Added a brand new class driver for ptp clocks.
Date: Mon, 18 Apr 2011 08:54:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
References: <cover.1303107532.git.richard.cochran@omicron.at> <7cabcc0bbd14733fa979fe08deccab8939204f24.1303107532.git.richard.cochran@omicron.at>
In-Reply-To: <7cabcc0bbd14733fa979fe08deccab8939204f24.1303107532.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104180854.35552.arnd@arndb.de>
X-Provags-ID: V02:K0:Noy4P0qFati2NEsdhbyIuLqr0kJbY1rgDmZ1j+ApL2x
 u9Toq5CXo4gvu9bIF+vAPKNtamnvvHiKY6WSRbXXbGwfEHXyfq
 +Z2i2lOE+kxwhqsUHDGM9u0rvlDTZMoNxpIwdfpakINjsLBoGz
 5ny72ggmkou3N7opbWGKhbIVI3FpvDu3ul+uoxyLo99Gy3AwpY
 nqQIg6EQTgeMAMZpt7Yew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Richard Cochran wrote:
> This patch adds an infrastructure for hardware clocks that implement
> IEEE 1588, the Precision Time Protocol (PTP). A class driver offers a
> registration method to particular hardware clock drivers. Each clock is
> presented as a standard POSIX clock.
> 
> The ancillary clock features are exposed in two different ways, via
> the sysfs and by a character device.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

Acked-by: Arnd Bergmann <arnd@arndb.de>
