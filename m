Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1AaLlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:41:47 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56329 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab1AaLlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:41:46 -0500
Date: Mon, 31 Jan 2011 06:41:01 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] dt: Move device tree documentation out of powerpc
 directory
Message-ID: <20110131114101.GD13541@zod.rchland.ibm.com>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
 <20110131074446.9058.52690.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131074446.9058.52690.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:44:57AM -0700, Grant Likely wrote:
>The device tree is used by more than just PowerPC.  Make the documentation
>directory available to all.
>
>v2: reorganized files while moving to create arch and driver specific
>    directories.

Thanks Grant.

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
