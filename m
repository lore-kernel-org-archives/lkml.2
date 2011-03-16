Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1CPO14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:27:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35713 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1CPO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U75cWSIWA3MTuHt6HL2q/VUvx11XLZ12RizvLsi0Qg/ZuSVQQ7+QygKTNFs0mzYoud
         Fw7hy+fQ3a/RPJt3+jUJzSlwkoJXC9bZMWaX3LlkT7On2QKsc26zZYfolnU1v2TN3SAN
         kgKpcPer+GLYBvE+ECyhjLUu6+5GjLgvcoxjk=
Date: Wed, 16 Mar 2011 15:26:03 +0100
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
Message-ID: <20110316142603.GC12435@riccoc20.at.omicron.at>
References: <cover.1298878618.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1298878618.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 08:57:03AM +0100, Richard Cochran wrote:
> * PHC Patch ChangeLog
> ** v12
> *** gianfar_ptp
>    - fixed up device tree
>    - inlined the header file
>    - use platform_ calls instead of deprecated of_ calls
>    - removed static global single instance
>    - removed John Stultz's ack from this patch

@Thomas and John:

Can I get your acks on the remaining patches?

Can this be merged for 2.6.39?

Thanks,

Richard
