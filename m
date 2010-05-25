Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0EYJwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:52:11 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:35109 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0EYJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:52:09 -0400
X-IronPort-AV: E=Sophos;i="4.53,297,1272844800"; 
   d="scan'208";a="71919"
Date: Tue, 25 May 2010 10:55:56 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Boris Derzhavets <bderzhavets@yahoo.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Stefano@yahoo.com" <Stefano@yahoo.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 0 of 12] PV on HVM Xen
In-Reply-To: <589587.84468.qm@web56105.mail.re3.yahoo.com>
Message-ID: <alpine.DEB.2.00.1005251055230.25605@kaball-desktop>
References: <589587.84468.qm@web56105.mail.re3.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Boris Derzhavets wrote:
> What Xen Version this patch is supposed to be applied ?
> Seems like not 4.0.
> 

xen-unstable, but it shouldn't be difficult to port to 4.0.
BTW I just sent an updated version of the patch to the list.
