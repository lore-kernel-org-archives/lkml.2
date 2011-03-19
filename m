Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1CSKOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 06:14:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37252 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab1CSKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 06:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xOVirPw/2rUpemuhgnhWtasek0c8bs9nUHuB7rvo+XVkhDW7HpTmW6D2M7r71QyZaG
         CE5ZmO88n4UdVQMGXN8ikp8Le0TA9jDdy+yBViy81DKs3/HwVKl7bljaGZ2kqHlNqtP/
         jXAuUtdWRXKGS5Acx3sUw+jxlVIKE8oTTUP3U=
Date: Sat, 19 Mar 2011 11:14:12 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V12 0/4] ptp: IEEE 1588 hardware clock support
Message-ID: <20110319101412.GA14207@riccoc20.at.omicron.at>
References: <cover.1298878618.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1298878618.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all those interested in the user space aspect, I have posted some
patches to ptpd project showing how the API works.

https://sourceforge.net/tracker/?group_id=139814&atid=744634

3225599 [PATCH 1/3] Convert to POSIX clock API.
3225603 [PATCH 2/3] Adapted to use the Linux PTP Hardware Clock API.
3225607 [PATCH 3/3] Adapted to use the newer SO_TIMESTAMPING Linux API.

Enjoy,

Richard

