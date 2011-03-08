Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1CHO1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:27:46 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:49658 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1CHO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:27:44 -0500
X-IronPort-AV: E=Sophos;i="4.62,284,1297036800"; 
   d="scan'208";a="4673979"
Date: Tue, 8 Mar 2011 14:27:24 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 0/2] x86: cleanup highmap after brk is concluded
In-Reply-To: <alpine.DEB.2.00.1103011133340.2917@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1103081427090.2968@kaball-desktop>
References: <alpine.DEB.2.00.1102281755270.2917@kaball-desktop> <4D6BECA3.2020300@kernel.org> <alpine.DEB.2.00.1103011133340.2917@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Stefano Stabellini wrote:
> On Mon, 28 Feb 2011, Yinghai Lu wrote:
> > Can you please rebase them on top of tip/x86/mm?
> > 
> > http://people.redhat.com/mingo/tip.git/readme.txt
> > 
>  
> Sure, I rebased the two patches on the very latest tip/x86/mm:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-tip-mm-fix
> 

ping?
