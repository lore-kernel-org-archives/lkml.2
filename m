Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336Ab0EEAB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:01:59 -0400
Received: from tundra.namei.org ([65.99.196.166]:58583 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667Ab0EEAB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:01:58 -0400
Date: Wed, 5 May 2010 10:01:54 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Jean-Christophe Dubois <jcd@tribudubois.net>,
       Serge Hallyn <serue@us.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] ima: remove ACPI dependency
In-Reply-To: <1273011390-6090-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1005051001420.12883@tundra.namei.org>
References: <1273011390-6090-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010, Mimi Zohar wrote:

> The ACPI dependency moved to the TPM, where it belongs.  Although
> IMA per-se does not require access to the bios measurement log,
> verifying the IMA boot aggregate does, which requires ACPI.
> 
> This patch prereq's 'TPM: ACPI/PNP dependency removal'
> http://lkml.org/lkml/2010/5/4/378.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Tested-by: Serge Hallyn <serue@us.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
