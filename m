Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab1ERPUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:20:43 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46456 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab1ERPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:20:41 -0400
Subject: Re: [PATCH V3 0/2] mm: Memory hotplug interface changes
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110518151131.GB4709@dumpdata.com>
References: <20110517213604.GA30232@router-fw-old.local.net-space.pl>
	 <20110518151131.GB4709@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 18 May 2011 08:20:23 -0700
Message-ID: <1305732023.9566.7.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 11:11 -0400, Konrad Rzeszutek Wilk wrote:
> Dave and David, you guys Acked them - are they suppose to go through your
> tree(s) or Andrew's? 

-mm is the appropriate place.

-- Dave

