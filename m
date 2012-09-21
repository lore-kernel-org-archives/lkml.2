Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2IUPl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:41:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33777 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2IUPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:41:26 -0400
Message-ID: <505C8AA3.3000109@wwwdotorg.org>
Date: Fri, 21 Sep 2012 09:41:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: grant.likely@secretlab.ca, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqdomain: Removed unused variable description
References: <1348211847-24252-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1348211847-24252-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 01:17 AM, Venu Byravarasu wrote:
> Removed description for unused variables: irq_base, nr_irq &
> hwirq_base, from the irq_domain structure.

The variables/fields aren't unused (present but not used) but rather not
present, deleted, or removed.
