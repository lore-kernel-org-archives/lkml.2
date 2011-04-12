Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1DLPY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:24:56 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:20754 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab1DLPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:24:55 -0400
X-IronPort-AV: E=Sophos;i="4.64,197,1301875200"; 
   d="scan'208";a="5268050"
Date: Tue, 12 Apr 2011 16:25:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [014/105] x86-64, mm: Put early page table high
In-Reply-To: <20110412143549.416968403@clark.kroah.org>
Message-ID: <alpine.DEB.2.00.1104121623410.22672@kaball-desktop>
References: <20110412143549.416968403@clark.kroah.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> 


this patch breaks Xen and there isn't even a fix upstream yet, so please
do not backport it

