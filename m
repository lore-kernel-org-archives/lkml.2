Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2JIMBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:01:44 -0400
Received: from plane.gmane.org ([80.91.229.3]:50818 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab2JIMBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:01:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v5 2/2] regulator: add device tree support for max8997
Followup-To: gmane.linux.drivers.devicetree
Date: Tue, 09 Oct 2012 14:01:23 +0200
Organization: Samsung Poland R&D Center
Message-ID: <k513mj$3o8$5@ger.gmane.org>
References: <1334741463-25058-1-git-send-email-thomas.abraham@linaro.org> <1334741463-25058-3-git-send-email-thomas.abraham@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 217-67-201-162.itsa.net.pl
User-Agent: KNode/4.9.2
Cc: devicetree-discuss@ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Abraham wrote:

> Add device tree based discovery support for max8997.
> 
> Cc: Karol Lewandowski <k.lewandowsk@samsung.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Are there any plans for merging this patch? It is a dependency of Samsung 
Trats board device tree support.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center

