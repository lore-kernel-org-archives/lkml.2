Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1EaS4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:56:48 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:62268 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab1EaS4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:56:47 -0400
Date: Tue, 31 May 2011 14:55:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Xen-devel] [PATCH V4] xen/balloon: Memory hotplug support for
 Xen balloon driver
Message-ID: <20110531185529.GA7734@dumpdata.com>
References: <20110524223657.GB29133@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524223657.GB29133@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DE539B4.0053:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

I just ran those two patches against v3.0-r1 (and under Xen as PV guests) and Andrew, if you want you can stick:

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

