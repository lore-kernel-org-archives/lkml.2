Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0CQPkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:40:17 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:48113 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0CQPkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:40:14 -0400
Message-ID: <4BA0F78F.9090804@oracle.com>
Date: Wed, 17 Mar 2010 08:38:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>
Subject: Re: linux-next: Tree for March 17 (gigaset isdn)
References: <20100317160803.78c63f94.sfr@canb.auug.org.au>
In-Reply-To: <20100317160803.78c63f94.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BA0F7D5.0140:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/10 22:08, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100316:


ERROR: "gigaset_isdn_regdev" [drivers/isdn/gigaset/gigaset.ko] undefined!
ERROR: "gigaset_isdn_regdrv" [drivers/isdn/gigaset/gigaset.ko] undefined!
ERROR: "gigaset_isdn_unregdrv" [drivers/isdn/gigaset/gigaset.ko] undefined!
ERROR: "gigaset_isdn_unregdev" [drivers/isdn/gigaset/gigaset.ko] undefined!

when
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=m # or =y

-- 
~Randy
