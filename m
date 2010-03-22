Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0CVPb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:31:27 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:43129 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab0CVPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:31:25 -0400
Message-ID: <4BA78D3D.9090007@oracle.com>
Date: Mon, 22 Mar 2010 08:31:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for March 22 (net-sysfs.c)
References: <20100322171937.d753bdba.sfr@canb.auug.org.au>
In-Reply-To: <20100322171937.d753bdba.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BA78D47.0147:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/10 23:19, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100319:
> 
> 
> The net tree lost its build failures.


When CONFIG_SYSFS is not enabled:

net/core/net-sysfs.c:742: error: implicit declaration of function 'rx_queue_remove_kobjects'
net/core/net-sysfs.c:783: error: implicit declaration of function 'rx_queue_register_kobjects'

-- 
~Randy
