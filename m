Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1AFJjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:39:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45213 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1AFJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:39:51 -0500
Date: Thu, 6 Jan 2011 09:39:40 +0000
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
Message-ID: <20110106093940.GA31708@n2100.arm.linux.org.uk>
References: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com> <4D245D16.5010702@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D245D16.5010702@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 12:59:18PM +0100, Carmelo AMOROSO wrote:
> Is someone interested into this stuff ?

Looking at the CC list, you're asking the people who already have the
support in the kernel.  I suspect they don't have that much of an
interest in it.

Maybe you should try asking other architecture maintainers who don't
support this yet?  Not every architecture maintainer is subscribed to,
or reads LKML...
