Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1KHM6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:58:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:13446 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab1KHM6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:58:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,477,1315206000"; 
   d="scan'208";a="87453421"
Date: Tue, 8 Nov 2011 14:58:33 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 03/19] usb: otg: Separate otg members from usb_phy
Message-ID: <20111108125833.GB2531@xps8300>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-4-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6L2YO5UL_upjfrsfWXOVDKhrQxP9wTt2Ci-+xXy8nTm0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAe_U6L2YO5UL_upjfrsfWXOVDKhrQxP9wTt2Ci-+xXy8nTm0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 07, 2011 at 04:57:49PM +0530, ABRAHAM, KISHON VIJAY wrote:
> > +struct usb_otg {
> > +       u8                      default_a;
> > +
> > +       struct usb_phy          *xceiv;
> _phy_ should be instead of _xceiv_. It's more self explanatory.

Yes, I agree. And I think Sascha Hauer suggested this, but I forgot to
change it.

I will make one more version of these.

Thanks,

-- 
heikki
