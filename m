Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab0EEABj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:01:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:58579 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0EEABh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:01:37 -0400
Date: Wed, 5 May 2010 10:01:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH] TPM: ACPI/PNP dependency removal
In-Reply-To: <1273009760.3532.41.camel@blackbox.ibm.com>
Message-ID: <alpine.LRH.2.00.1005051001210.12883@tundra.namei.org>
References: <1273009760.3532.41.camel@blackbox.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010, Rajiv Andrade wrote:

> This patch pushes the ACPI dependency into the device driver code
> itself. Now, even without ACPI/PNP enabled, the device can be registered
> using the TIS specified memory space. This will however result in the
> lack of access to the bios event log, being the only implication of such
> ACPI removal.
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
