Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab1JRJHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:07:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:8109 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1JRJHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:07:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,364,1315206000"; 
   d="scan'208";a="74977977"
Date: Tue, 18 Oct 2011 11:11:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, khilman@ti.com, b-cousson@ti.com,
        paul@pwsan.com, gadiyar@ti.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH v14] mfd: omap: usb: Runtime PM support
Message-ID: <20111018091109.GC7694@sortiz-mobl>
References: <1318319609-20522-1-git-send-email-keshava_mgowda@ti.com>
 <20111013173204.GL28290@legolas.emea.dhcp.ti.com>
 <CAP05o4K6RS5YawJ8POy7ZifJ7W8MRA0d77iwjZZ1ojTQnQS=nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP05o4K6RS5YawJ8POy7ZifJ7W8MRA0d77iwjZZ1ojTQnQS=nA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On Tue, Oct 18, 2011 at 11:37:28AM +0530, Munegowda, Keshava wrote:
> On Thu, Oct 13, 2011 at 11:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Oct 11, 2011 at 01:23:29PM +0530, Keshava Munegowda wrote:
> >> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> >>
> >> The usbhs core driver does not enable/disable the interface and
> >> functional clocks directly, These clocks are handled by runtime pm,
> >> hence instead of the clock enable/disable, the runtime pm APIS are
> >> used. however,the optional clocks and port clocks are handled by
> >> the usbhs core.
> >>
> >> Dependency:
> >> This patch is dependent on this series:
> >> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation
> >> for EHCI and OHCI drivers.
> >>
> >> Validation performed:
> >> The global suspend/resume of EHCI and OHCI is validated on
> >> OMAP3430 sdp board with this patch combined with the series:
> >> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation
> >> for EHCI and OHCI drivers.
> >>
> >> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> >> Reviewed-by: Kevin Hilman <khilman@ti.com>
> >> Reviewed-by: Partha Basak <parthab@india.ti.com>
> >
> 
> 
> Hi Sameo
>         The prior series of this patch is acked by balbi , paul ,
> benoit and kevin.
> I request if you think everything is OK in this patch please ack ;
> otherwise if you have any review comment I have to close them ASAP.
I replied to an email from Paul and ACKed it. I just realized that you were
not cc'ed on this one, let me forward it to you.
This patch should be queued on the OMAP tree now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
