Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0E0SGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:06:12 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60288 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab0E0SGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:06:09 -0400
X-IronPort-AV: E=Sophos;i="4.53,312,1272844800"; 
   d="scan'208";a="127611"
Date: Thu, 27 May 2010 19:10:08 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ian Jackson <Ian.Jackson@eu.citrix.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH 11/11] Unplug emulated disks and nics
In-Reply-To: <4BFEB11D.9080805@goop.org>
Message-ID: <alpine.DEB.2.00.1005271908590.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-11-git-send-email-stefano.stabellini@eu.citrix.com> <4BFC3390.4060503@goop.org> <alpine.DEB.2.00.1005261325110.25605@kaball-desktop> <4BFD8BB0.90301@goop.org>
 <m2n.s.1OHcBK-0018DA@chiark.greenend.org.uk> <19454.34430.471499.222290@mariner.uk.xensource.com> <4BFEB11D.9080805@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Jeremy Fitzhardinge wrote:
> We could include 2 bytes of the HEAD changeset or something, with some
> risk of collision.  Or just choose a constant and stick with it until
> some interesting qualitative driver change makes it worthwhile bumping
> the version.
> 

the constant would be more useful than a CS I think

