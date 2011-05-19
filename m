Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab1ESQSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:18:08 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33484
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732Ab1ESQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:18:06 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD542BA.6040608@freescale.com>
Date: Thu, 19 May 2011 11:18:02 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/2.0.14-1.fc13 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-7-git-send-email-timur@freescale.com> <20110519153358.5876f310@lxorguk.ukuu.org.uk> <4DD533DE.1020705@freescale.com> <20110519165039.7fd8ec34@lxorguk.ukuu.org.uk> <4DD53D1B.4060600@freescale.com> <20110519160239.GB25606@kroah.com>
In-Reply-To: <20110519160239.GB25606@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> It's too late, it needed to be in linux-next _before_ the window opened.
> 
> sorry,

Curses!  Foiled again!

Well, then I'd like to get this patchset fixed up and approved soon after the
window closes, so that there's no excuse for missing 2.6.41.

-- 
Timur Tabi
Linux kernel developer at Freescale

