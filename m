Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0EXTDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:03:12 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20269 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0EXTDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:03:11 -0400
X-IronPort-AV: E=Sophos;i="4.53,292,1272844800"; 
   d="scan'208";a="62267"
Date: Mon, 24 May 2010 20:06:57 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Boris Derzhavets <bderzhavets@yahoo.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 0 of 12] PV on HVM Xen
In-Reply-To: <596969.543.qm@web56103.mail.re3.yahoo.com>
Message-ID: <alpine.DEB.2.00.1005242006360.25605@kaball-desktop>
References: <596969.543.qm@web56103.mail.re3.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010, Boris Derzhavets wrote:
> > In order to be able to use VIRQ_TIMER and to improve performances you
> > need a patch to Xen to implement the vector callback mechanism
> > for event channel delivery.
> 
> Where to get it ?
> 

It is this one:

http://lists.xensource.com/archives/html/xen-devel/2010-05/msg00875.html

