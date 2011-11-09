Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab1KIJFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:05:47 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:45818 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1KIJFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:05:45 -0500
Message-ID: <4EBA4258.3070800@oracle.com>
Date: Wed, 09 Nov 2011 17:05:28 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, jeremy@goop.org
CC: Paul Durrant <paul.durrant@citrix.com>,
        Kurt Hackel <Kurt.Hackel@oracle.com>
Subject: Re: [Xen-devel] patches of upstreaming grant table version 2
References: <4EBA35D3.3020506@oracle.com>
In-Reply-To: <4EBA35D3.3020506@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4EBA4264.00DF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diff and shortlog:

  arch/x86/xen/grant-table.c          |   39 ++++-
  drivers/xen/grant-table.c           |  354 
++++++++++++++++++++++++++++++++---
  include/xen/grant_table.h           |    8 +-
  include/xen/interface/grant_table.h |  167 ++++++++++++++++-
  include/xen/interface/xen.h         |    2 +
  5 files changed, 534 insertions(+), 36 deletions(-)

Annie Li (3):
       Introducing grant table V2 stucture
       Grant tables v2 implementation.
       code clean up

Thanks
Annie
