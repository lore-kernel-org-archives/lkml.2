Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2LCG3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:29:44 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:43366 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2LCG3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:29:43 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlllAHVGvFBV5qjOPGdsb2JhbABEhUOFI7UYFwMBAQEBODSCHgEBBAE6HCMFCwgDRhQlChqIHQq+IRSQDGEDlgCFe41A
X-IronPort-AV: E=Sophos;i="4.83,361,1352070000"; 
   d="scan'208";a="456958934"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 3 Dec 2012 07:31:24 +0100
To: Dudley Du <dudl@cypress.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        customercare <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        "dudl@cyress.com" <dudl@cyress.com>
Subject: Re: [PATCH v3 2/4] input: Cypress PS/2 Trackpad psmouse driver
Message-ID: <20121203063124.GA2609@polaris.bitmath.org>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
 <1354226281-3476-3-git-send-email-kamal@canonical.com>
 <B27AC323FA92C946BA36D2913DDC8E370234D97E49AE@VMBX126.ihostexchange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B27AC323FA92C946BA36D2913DDC8E370234D97E49AE@VMBX126.ihostexchange.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

> Another question is that new interface input_mt_assign_slots() is introduced since 3.7-rc7 or later,
> So we could not support the kernel releases that earlier than 3.7-rc7 with this driver.

The patch is a submission to mainline, so of course it should be in sync with mainline.

Thanks.
Henrik
