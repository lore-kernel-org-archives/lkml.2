Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab1KPNXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:23:49 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59883 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab1KPNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:23:48 -0500
Message-ID: <4EC3B94C.1040103@oracle.com>
Date: Wed, 16 Nov 2011 21:23:24 +0800
From: annie li <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
CC: Kurt.Hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com
Subject: Re: [Xen-devel] Improved patches of upstreaming grant table version
 2
References: <4EC3B62F.6080702@oracle.com>
In-Reply-To: <4EC3B62F.6080702@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4EC3B95E.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diff:

 arch/x86/xen/grant-table.c          |   42 ++++-
 drivers/xen/grant-table.c           |  355 
++++++++++++++++++++++++++++++----
 include/xen/grant_table.h           |   10 +-
 include/xen/interface/grant_table.h |  167 ++++++++++++++++-
 include/xen/interface/xen.h         |    2 +
 5 files changed, 521 insertions(+), 55 deletions(-)


Short log:

Annie Li (3):
      xen/granttable: Introducing grant table V2 stucture
      xen/granttable: Grant tables V2 implementation
      xen/granttable: Keep code format clean

Thanks
Annie
