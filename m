Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1K2Akw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:40:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18196 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1K2Akv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:40:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 28 Nov 2011 16:40:50 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
CC: Rob Herring <rob.herring@calxeda.com>
Date: Mon, 28 Nov 2011 16:40:49 -0800
Subject: RE: [PATCH] of/irq: of_irq_init: add check for parent equal to
 child node
Thread-Topic: [PATCH] of/irq: of_irq_init: add check for parent equal to
 child node
Thread-Index: AcyteGPz7KFnaoIET9iw9os0Wyv65QAtvnng
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDAF9C4@HQMAIL01.nvidia.com>
References: <1322448550-15392-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1322448550-15392-1-git-send-email-robherring2@gmail.com>
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

Rob Herring wrote at Sunday, November 27, 2011 7:49 PM:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> With the revert of "of/irq: of_irq_find_parent: check for parent equal to
> child" (dc9372808412edb), we need another way to handle parent node equal
> to the child node. This can simply be handled in of_irq_init by checking
> for this condition.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Tested-by: Stephen Warren <swarren@nvidia.com>

This fixed the issue I was having testing a Tegra patch that converted
over to the new ARM GIC bindings.

-- 
nvpublic

