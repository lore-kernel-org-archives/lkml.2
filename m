Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0EQQLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:11:51 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44933 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0EQQLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:11:50 -0400
Date: Mon, 17 May 2010 11:06:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] mem-hotplug: avoid multiple zones sharing same boot
 strapping boot_pageset
In-Reply-To: <4BF0FC13.4090206@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1005171106150.20764@router.home>
References: <4BF0FC13.4090206@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


