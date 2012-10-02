Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2JBSvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:51:21 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45904 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2JBSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:51:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210021724300.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210021724300.29232@kaball.uk.xensource.com>
Date: Tue, 2 Oct 2012 14:51:19 -0400
X-Google-Sender-Auth: H2o8dullfBLSkNXiLKMs9X_pMUE
Message-ID: <CACJDEmrV4uqLQ5wPGTQ7vHRAo3hHXDdWrTB5h65hfF+B9rJCgQ@mail.gmail.com>
Subject: Re: [PATCH] xen: resolve merge conflict with 617276307cd4cdb9a95c77efaa3063695af63aa7
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xensource.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 1:29 PM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> The Xen tree tries to add a line to
> arch/arm/mach-vexpress/Makefile.boot that has been removed by the
> following commit in Linus' master:
>
> commit 617276307cd4cdb9a95c77efaa3063695af63aa7
> Author: Rob Herring <rob.herring@calxeda.com>
> Date:   Thu Sep 6 13:43:04 2012 -0500
>
>     ARM: vexpress: convert to multi-platform
>
> In fact the dts Makefile is now arch/arm/boot/dts/Makefile, as per
> commit 9cd11c0c47b8690b47e7573311ce5c483cb344ed.
>
>
> This is the merge resolution patch.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Great. Thanks for posting it!
