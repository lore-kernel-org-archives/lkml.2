Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2FXHvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 03:51:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52142 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2FXHvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 03:51:21 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
        "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        David Miller <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>
Subject: RE: [PATCH] NFC: prevent multiple buffer overflows in NCI
Thread-Topic: [PATCH] NFC: prevent multiple buffer overflows in NCI
Thread-Index: AQHNT+fsxYsi0WT2AUi19pKRQ1D5HpcJG7ZA
Date: Sun, 24 Jun 2012 07:50:05 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803516AC8DC9@DNCE04.ent.ti.com>
References: <4FE37C5C.4090009@gmail.com>
In-Reply-To: <4FE37C5C.4090009@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.131.83]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,  

> From: Dan Rosenberg [mailto:dan.j.rosenberg@gmail.com] 
> Sent: Thursday, June 21, 2012 10:56 PM
> To: lauro.venancio@openbossa.org; 
> aloisio.almeida@openbossa.org; sameo@linux.intel.com; David 
> Miller; Elias, Ilan
> Cc: linux-kernel@vger.kernel.org; security@kernel.org; 
> linux-netdev@vger.kernel.org
> Subject: [PATCH] NFC: prevent multiple buffer overflows in NCI
> 
> Fix multiple remotely-exploitable stack-based buffer 
> overflows due to the NCI
> code pulling length fields directly from incoming frames and 
> copying too much
> data into statically-sized arrays. Fortunately, there don't 
> appear to be any
> active users of this code (yet).
> 
> This patch fixes the overflows, but I suspect the code will need to be
> completely reworked since this doesn't address the more 
> systemic problem of
> failing to check that the values read from incoming frame 
> data aren't from
> beyond the end of the pulled skb data. Build tested only.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> Cc: stable@kernel.org
> Cc: security@kernel.org
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Ilan Elias <ilane@ti.com>
Acked-by: Ilan Elias <ilane@ti.com>

Thanks & BR,
Ilan
 