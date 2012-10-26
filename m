Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab2JZH62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:58:28 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:12631 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2JZH61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:58:27 -0400
X-IronPort-AV: E=Sophos;i="4.80,653,1344211200"; 
   d="scan'208";a="15402717"
Message-ID: <1351238303.18035.236.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/5] xen: arm: implement remap interfaces
 needed for privcmd mappings.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: xen-devel <xen-devel@lists.xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 26 Oct 2012 08:58:23 +0100
In-Reply-To: <20121025183958.0a4ae846@mantra.us.oracle.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
	 <1351084777-28898-4-git-send-email-ian.campbell@citrix.com>
	 <20121024164411.5b000087@mantra.us.oracle.com>
	 <20121024170746.7c89a790@mantra.us.oracle.com>
	 <1351151219.18035.94.camel@zakaz.uk.xensource.com>
	 <20121025183958.0a4ae846@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 02:39 +0100, Mukesh Rathor wrote:
> Yup. I made the change on xen side and added this patch to my tree
> and got it working after reverting Konrad's setup.c changes. Not sure
> if you need an ack from x86, but if you do:
> 
> Acked-by: Mukesh Rathor <mukesh.rathor@oracle.com>

The more ack's the merrier, thanks!


