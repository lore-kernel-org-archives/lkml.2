Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1BWKuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:50:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40626 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1BWKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:50:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tCmjewzpeI7PLDHTDA7VwDtzZVFNyB4x0u0f6fdIZpaEqbwZmpTaegrQCgkWpi9Ni/
         AEj9upsb+LAvmNz8fi16Zp0GiSya1tgzmYqkslGsIDbgU2GcRFNzc4dlmvitG6IDbd0z
         1PvZqrq/HtM2AuZezOc2LkE8tfQpP2wPaKw7A=
Date: Wed, 23 Feb 2011 11:50:07 +0100
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
Subject: Re: [PATCH V11 0/4] ptp: IEEE 1588 hardware clock support
Message-ID: <20110223105007.GA31292@riccoc20.at.omicron.at>
References: <cover.1298447722.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1298447722.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Previous Discussions

  This patch set previously appeared on the netdev list. Since V5 of
  the character device patch set, the discussion has moved to the
  lkml.

  - IEEE 1588 hardware clock support [V5]
    http://lkml.org/lkml/2010/8/16/90

  - POSIX clock tuning syscall with static clock ids
    http://lkml.org/lkml/2010/8/23/49

  - POSIX clock tuning syscall with dynamic clock ids
    http://lkml.org/lkml/2010/9/3/119

  - IEEE 1588 hardware clock support [V6]
    http://lkml.org/lkml/2010/9/23/310

  - Dynamic clock devices [RFC]
    http://lkml.org/lkml/2010/11/4/290

  - IEEE 1588 hardware clock support [V7]
    http://lkml.org/lkml/2010/12/16/195

  - IEEE 1588 hardware clock support [V8]
    http://lkml.org/lkml/2010/12/31/128

  - IEEE 1588 hardware clock support [V9]
    http://lkml.org/lkml/2011/1/13/65

  - IEEE 1588 hardware clock support [V10]
    http://lkml.org/lkml/2011/1/27/71

  - Thomas Gleixner: Rework of the PTP support series core code
    http://lkml.org/lkml/2011/2/1/137
