Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab2JWJvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:51:12 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:53075 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab2JWJvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:51:10 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "m.d.s.x.jonker@gmail.com" <m.d.s.x.jonker@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: RE: [PATCH v4 1/1] Input: serio - Add ARC PS/2 driver
Thread-Topic: [PATCH v4 1/1] Input: serio - Add ARC PS/2 driver
Thread-Index: AQHNrRMNjgUpxVN9PUuxvF1MmQgcJpfGZOWAgAA/3TA=
Date: Tue, 23 Oct 2012 09:51:06 +0000
Message-ID: <E6BF041E97966E4DB955F0DF883AD2D6019EF2@DE02WEMBX1.internal.synopsys.com>
References: <1350552538-24343-1-git-send-email-mischa.jonker@synopsys.com>
 <1350552538-24343-2-git-send-email-mischa.jonker@synopsys.com>
 <20121023073033.GA19595@core.coreip.homeip.net>
In-Reply-To: <20121023073033.GA19595@core.coreip.homeip.net>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.24.59]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,


> > This adds support for the PS/2 block that is used in various ARC FPGA 
> > platforms.
> Applied with minor edits, please take a look at my 'next' branch and holler if you see something wrong.

Looks good & works fine, thanks for applying!


> BTW, does the patch below work for you?
> [patch to use managed resources]

Looks good to me. Tested, works OK. 


Thanks,

Mischa
