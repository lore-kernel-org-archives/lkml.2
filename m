Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2IQRaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:30:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:31849 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab2IQRaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:30:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,437,1344236400"; 
   d="scan'208";a="145985350"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [PATCH 1/2] x86, mce: Enable MCA support by default
Thread-Topic: [PATCH 1/2] x86, mce: Enable MCA support by default
Thread-Index: AQHNlPTOaUYUlHqu1ECzCZwBUDzTZ5eOw9lA
Date: Mon, 17 Sep 2012 17:30:00 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D41BC2@ORSMSX108.amr.corp.intel.com>
References: <1347900723-17490-1-git-send-email-bp@amd64.org>
 <1347900723-17490-2-git-send-email-bp@amd64.org>
In-Reply-To: <1347900723-17490-2-git-send-email-bp@amd64.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> MCA is the basic support for hardware error logging and reporting, and
> it is majorly unwise to run without it so enable machine check software
> support by default on x86.

Acked-by: Tony Luck <tony.luck@intel.com>
