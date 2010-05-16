Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab0EPXJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 19:09:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:59494 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab0EPXJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 19:09:40 -0400
Date: Mon, 17 May 2010 09:09:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       zohar@linux.vnet.ibm.com
Subject: Re: [PATCH] TPM: ACPI/PNP dependency removal
In-Reply-To: <1273783074.8536.6.camel@blackbox.ibm.com>
Message-ID: <alpine.LRH.2.00.1005170909220.12313@tundra.namei.org>
References: <1273782204.8536.4.camel@blackbox.ibm.com>  <4BEC6141.2010201@oracle.com> <1273783074.8536.6.camel@blackbox.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Rajiv Andrade wrote:

> This patch pushes the ACPI dependency into the device driver code
> itself. Now, even without ACPI/PNP enabled, the device can be registered
> using the TIS specified memory space. This will however result in the
> lack of access to the BIOS event log, being the only implication of such
> ACPI removal.
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
