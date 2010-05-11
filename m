Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0EKQLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:11:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:44960 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0EKQLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:11:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,208,1272870000"; 
   d="scan'208";a="620750745"
From: "Du, Alek" <alek.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 00:10:54 +0800
Subject: RE: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Topic: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Index: AcrxItTNml+mzW4XRziCgLhaBWKgEQAAVBoQ
Message-ID: <1865303E0DED764181A9D882DEF65FB61A82CECA8A@shsmsx502.ccr.corp.intel.com>
References: <20100511113120.02787f96@dxy2>
 <Pine.LNX.4.44L0.1005111156150.1834-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005111156150.1834-100000@iolanthe.rowland.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Alan Stern [mailto:stern@rowland.harvard.edu]
>Sent: Tuesday, May 11, 2010 11:58 PM
>To: Du, Alek
>Cc: Ondrej Zary; Linux-pm mailing list; USB list; Kernel development list
>Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
>(WKOC_E) and disconnect (WKDISC_E)
>
>Alek:
>
>By the way, does the Moorestown platform support multiple ports
>on the root hub?  If it does then using a single time delay (instead of
>a separate delay for each port) makes sense.  But if it doesn't then
>there's no reason to move the power-up and power-down delays outside
>the port loops.
>
>Alan Stern

Alan,

Yes, the Moorestown platform supports multi-ports, actually my test board has three ports on the root hub.

Thanks,
Alek


