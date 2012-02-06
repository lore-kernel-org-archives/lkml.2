Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2BFBvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:51:40 -0500
Received: from tundra.namei.org ([65.99.196.166]:51318 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab2BFBvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:51:38 -0500
Date: Mon, 6 Feb 2012 12:51:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
In-Reply-To: <cover.1328122362.git.dmitry.kasatkin@intel.com>
Message-ID: <alpine.LRH.2.00.1202061250400.16907@tundra.namei.org>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Dmitry Kasatkin wrote:

> Hi,
> 
> Here is another module verification patchset, which is based on the recently
> upstreamed digital signature support used by EVM and IMA-appraisal.

You should cc: Rusty on any changes to the module code.


-- 
James Morris
<jmorris@namei.org>
