Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2HGHcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:32:36 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:11184 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2HGHce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:32:34 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <key@linux.vnet.ibm.com>
CC: <jmorris@namei.org>, <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>, <bfreed@chromium.org>,
        <safford@linux.vnet.ibm.com>, <hpa@linux.intel.com>
Subject: RE: [PATCH] char/tpm: Use struct dev_pm_ops for power management.
Thread-Topic: [PATCH] char/tpm: Use struct dev_pm_ops for power management.
Thread-Index: AQHNc6lgPonmiSa9PEe76qWHLPkk/JdNCt+AgADpNNA=
Date: Tue, 7 Aug 2012 07:30:35 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440E0CC7@MUCSE501.eu.infineon.com>
References: <20120803203836.GA11918@linux.vnet.ibm.com>
 <1344239939-5752-1-git-send-email-peter.huewe@infineon.com>
 <20120806192957.GB6821@linux.vnet.ibm.com>
In-Reply-To: <20120806192957.GB6821@linux.vnet.ibm.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

> Thanks Peter. One more request - can you roll this fix into the driver
> patch itself and just add a note in the change log?  Sorry I didn't
> mention this before.

Yes I'll do that.
And while at it I'll also replace our i2c_transfer_nolock with the new (in 3.6rc-1) __i2c_transfer function and 
integrate Bryans Patch directly into the driver.

Peter


