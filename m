Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2DTSpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:45:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34409 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2DTSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:45:16 -0400
Date: Fri, 20 Apr 2012 14:40:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120420184001.GA447@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F91AEAF.0040,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 01:29:06PM +0000, Liu, Jinsong wrote:
> >From af4467b6cf0104ce98cc160438d865256c7d5561 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Fri, 20 Apr 2012 05:08:38 +0800
> Subject: [PATCH 1/3] Add mcelog support for xen platform
> 
> When MCA error occurs, it would be handled by xen hypervisor first,
> and then the error information would be sent to dom0 for logging.

How do I test this?
