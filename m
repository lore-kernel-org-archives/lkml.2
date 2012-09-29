Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2I2VG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 17:06:28 -0400
Received: from jdl.com ([208.123.74.7]:57062 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab2I2VG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 17:06:27 -0400
Message-Id: <E1TI4Et-0004d5-Ql@jdl.com>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] dtc: import latest upstream dtc
In-reply-to: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org>
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org>
Comments: In-reply-to Stephen Warren <swarren@wwwdotorg.org>
   message dated "Fri, 28 Sep 2012 15:25:59 -0600."
Date: Sat, 29 Sep 2012 16:06:19 -0500
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: -0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Warren <swarren@nvidia.com>
> 
> This updates scripts/dtc to commit 317a5d9 "dtc: zero out new label
> objects" from git://git.jdl.com/software/dtc.git.
> 
> This adds features such as:
> * /bits/ syntax for cell data.
> * Math expressions within cell data.
> * The ability to delete properties or nodes.
> * Support for #line directives in the input file, which allows the use of
>   cpp on *.dts.
> * -i command-line option (/include/ path)
> * -W/-E command-line options for error/warning control.
> * Removal of spew to STDOUT containing the filename being compiled.
> * Many additions to the libfdt API.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

For what it might be worth:

Acked-by: Jon Loeliger <jdl@jdl.com>

jdl
