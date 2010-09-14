Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0ING4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:56:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38514 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0ING4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 02:56:21 -0400
Date: Tue, 14 Sep 2010 09:56:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Ming Lei <tom.leiming@gmail.com>, "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
Message-ID: <20100914065604.GD2601@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
 <1283873014-32511-6-git-send-email-tom.leiming@gmail.com>
 <4C8E18AD.8000502@ru.mvista.com>
 <AANLkTinei3u1OZ-eBiUTDF=PDjwxLcL6rBpt7iNQJgHJ@mail.gmail.com>
 <4C8E4882.6040600@ru.mvista.com>
 <4C8E50CC.3080705@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4C8E50CC.3080705@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 13, 2010 at 11:26:52AM -0500, Sergei Shtylyov wrote:
> Oops, I've been too fast and haven't realized that the check done here
> _is_ actually wrong. It causes ZLP send to trigger too fast in the DMA
> case. So please fix this patch. Felipe, please drop it for now.

patch is not even touching that part of the code, not even
reading/writing TXCSR_TXPKTRDY bit care to explain please.

-- 
balbi
