Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1AFOT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:19:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40335 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1AFOT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:19:56 -0500
Date: Thu, 6 Jan 2011 14:19:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Carmelo AMOROSO <carmelo.amoroso@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Filippo ARCIDIACONO <filippo.arcidiacono@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] stackprotector: add stack smashing protector
	generic implementation
Message-ID: <20110106141946.GE31708@n2100.arm.linux.org.uk>
References: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com> <4D245D16.5010702@st.com> <20110106093940.GA31708@n2100.arm.linux.org.uk> <4D25CEB9.7090205@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D25CEB9.7090205@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 03:16:25PM +0100, Carmelo AMOROSO wrote:
> Well, SH (in CC) does not have this support. Indeed we posted it
> initially to linux-sh only. We got useful feedback from Paul, Mike and
> Nicolas suggesting to promote the ARM/SH solution based on the global
> __stack_chk_guard variable as a generic solution for all other
> architectures. This is why I thought to post to the LKML instead of each
> linux-<arch> list.

Have you thought about posting it to _the_ linux-arch list?
