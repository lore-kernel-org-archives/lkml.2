Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2EXKdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:33:44 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:45765 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab2EXKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:33:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,649,1330905600"; 
   d="scan'208";a="12646027"
Date: Thu, 24 May 2012 11:33:27 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/4] xen/hvc: Collapse error logic.
In-Reply-To: <1337795222-29946-2-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.00.1205241133011.26786@kaball-desktop>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com> <1337795222-29946-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> All of the error paths are doing the same logic. In which
> case we might as well collapse them in one path.
> 
> CC: stable@kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
