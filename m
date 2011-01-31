Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab1AaLYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:24:48 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45809 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1AaLYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:24:47 -0500
Date: Mon, 31 Jan 2011 06:24:00 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 3/3 RFC] dt: add documentation of ARM dt boot interface
Message-ID: <20110131112400.GB13541@zod.rchland.ibm.com>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
 <20110131074510.9058.59071.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131074510.9058.59071.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:45:41AM -0700, Grant Likely wrote:
>Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>---
>
>For RFC only.  I do not plan to merge this change yet.
>
>g.
>
> Documentation/devicetree/booting-without-of.txt |   40 +++++++++++++++++++++++
> 1 files changed, 40 insertions(+), 0 deletions(-)
>
>diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
>index 6bca668..3950aea 100644
>--- a/Documentation/devicetree/booting-without-of.txt
>+++ b/Documentation/devicetree/booting-without-of.txt
>@@ -232,6 +233,45 @@ it with special cases.
>   cannot support both configurations with Book E and configurations
>   with classic Powerpc architectures.
>
>+2) Entry point for arch/arm
>+---------------------------
>+
>+   There is one and one single entry point to the kernel, at the start

"one and one" ?

josh
