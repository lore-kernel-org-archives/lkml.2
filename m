Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1CIN6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:58:55 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:1605 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab1CIN6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:58:53 -0500
X-IronPort-AV: E=Sophos;i="4.62,290,1297036800"; 
   d="scan'208";a="4696673"
Date: Wed, 9 Mar 2011 13:58:30 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Daniel Kiper <dkiper@net-space.pl>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH R4 2/7] xen/balloon: HVM mode support
In-Reply-To: <20110308214636.GC27331@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1103091356370.2968@kaball-desktop>
References: <20110308214636.GC27331@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, Daniel Kiper wrote:
> HVM mode support.

I have already a patch in linux-next to do this, please give a look at
"xen: make the ballon driver work for hvm domains":

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git linux-next

