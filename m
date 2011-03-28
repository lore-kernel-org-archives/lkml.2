Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1C1PYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:24:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37405 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1C1PYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:24:23 -0400
Subject: Re: [PATCH 1/3] mm: Optimize pfn calculation in online_page()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110328092310.GB13826@router-fw-old.local.net-space.pl>
References: <20110328092310.GB13826@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 28 Mar 2011 08:24:13 -0700
Message-ID: <1301325853.31700.8284.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 11:23 +0200, Daniel Kiper wrote:
> If CONFIG_FLATMEM is enabled pfn is calculated in online_page()
> more than once. It is possible to optimize that and use value
> established at beginning of that function.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl> 

Looks sensible to me.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com

