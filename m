Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1K1Ky6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:54:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53486 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1K1Ky5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:54:57 -0500
Subject: Re: [PATCH] of/irq: of_irq_init: add check for parent equal to
 child node
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <1322448550-15392-1-git-send-email-robherring2@gmail.com>
References: <1322448550-15392-1-git-send-email-robherring2@gmail.com>
Date: Mon, 28 Nov 2011 10:54:46 +0000
Message-ID: <1322477686.3164.31.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 28 Nov 2011 10:54:51.0472 (UTC) FILETIME=[277AD500:01CCADBC]
X-MC-Unique: 111112810545303301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 20:49 -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> With the revert of "of/irq: of_irq_find_parent: check for parent equal to
> child" (dc9372808412edb), we need another way to handle parent node equal
> to the child node. This can simply be handled in of_irq_init by checking
> for this condition.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Works for me, thanks!

Tested-by: Pawel Moll <pawel.moll@arm.com>

Cheers!

Paweł



