Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2IJAZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:25:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:19997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab2IJAZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:25:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="219832701"
Message-ID: <1347236699.28607.17.camel@yhuang-dev>
Subject: Re: Question about failure in PCI power-state change
From: Huang Ying <ying.huang@intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?=E6=9D=8E=E6=9C=9D=E6=98=8E?= 
	<chaoming_li@realsil.com.cn>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Mon, 10 Sep 2012 08:24:59 +0800
In-Reply-To: <CAErSpo7GEkN1XLZ=UeXmDZrLnp_648mH-sLYa9hMgOqz7t+b7Q@mail.gmail.com>
References: <504A78E9.4030005@lwfinger.net>
	 <CAErSpo7GEkN1XLZ=UeXmDZrLnp_648mH-sLYa9hMgOqz7t+b7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 15:48 -0700, Bjorn Helgaas wrote:
> +cc Rafael, Huang, linux-pm
> 
> On Fri, Sep 7, 2012 at 3:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > Hi,
> >
> > On occasion when I unload and reload driver rtl8192ce, I get the message
> >
> > "Refused to change power state, currently in D3"

Hi, Larry,

We fixed a similar issue recently.  And the patch has been merged by
v3.6-rc5.  Can you try v3.6-rc5?

Best Regards,
Huang Ying


