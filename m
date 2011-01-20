Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1ATHnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:43:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:63760 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab1ATHnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:43:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,349,1291622400"; 
   d="scan'208";a="649107114"
From: "Wu, Hao" <hao.wu@intel.com>
To: Yang Ruirui <ruirui.r.yang@tieto.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        "Du, Alek" <alek.du@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Jan 2011 15:42:44 +0800
Subject: RE: [PATCH v2] usb langwell otg: use notifier chain of struct
 otg_transceiver
Thread-Topic: [PATCH v2] usb langwell otg: use notifier chain of struct
 otg_transceiver
Thread-Index: Acu4b1SapiET6wX5TWiDxov/IzyFjQABI7tQ
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A31C3E9E2@shsmsx501.ccr.corp.intel.com>
References: <20110120070513.GA24956@darkstar>
In-Reply-To: <20110120070513.GA24956@darkstar>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 03:05:13PM +0800, Yang Ruirui wrote:
> Use notifier chain in otg_transceiver instead of own notifier chain.
>
> This patch depends on another patch which change otg_transceiver
>notifier chain to atomic one, please see:
>https://lkml.org/lkml/2011/1/19/72

Looks good to me, no need to keep its own atomic notifier chain if struct otg_transceiver has one.

>Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
>Reviewed-by: Felipe Balbi <balbi@ti.com>

Thanks
Hao
