Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2IDMKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:10:20 -0400
Received: from usa7109mr003.acs-inc.com ([63.101.151.12]:18906 "EHLO
	USA7109MR003.ACS-INC.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab2IDMKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:10:18 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 08:10:18 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] sata_fsl: add workaround for data length mismatch on freescale V2 controller
Date: Tue, 4 Sep 2012 13:00:28 +0100
Message-ID: <929D3CED81F34E43887A393170D66FB906C13480@GBRSUN01MS002.eu.xerox.net>
In-Reply-To: <1346756920-19128-1-git-send-email-Shaohui.Xie@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sata_fsl: add workaround for data length mismatch on freescale V2 controller
Thread-Index: Ac2Kklnyb7vvkOuySAWGalzZVFNadQAAgTIA
References: <1346756920-19128-1-git-send-email-Shaohui.Xie@freescale.com>
From: "Jenkins, Clive" <Clive.Jenkins@xerox.com>
To: Shaohui Xie <Shaohui.Xie@freescale.com>, <jgarzik@pobox.com>,
        <linux-ide@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Anju Bhartiya <Anju.Bhartiya@freescale.com>
X-OriginalArrivalTime: 04 Sep 2012 12:00:31.0195 (UTC) FILETIME=[E1D09AB0:01CD8A94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The freescale V2 SATA controller checks
> if the received data length matches
> the programmed length 'ttl', if not,
> it assumes that this is an error.
...

Can you tell us exactly what
"The freescale V2 SATA controller" is,
and what versions of what devices contain it?

Thanks,
Clive
