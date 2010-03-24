Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0CXTqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:46:24 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:59392 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab0CXTqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:46:22 -0400
Message-ID: <4BAA6B88.2080803@oracle.com>
Date: Wed, 24 Mar 2010 12:44:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>,
       Forest Bond <forest@alittletooquiet.net>
Subject: Re: linux-next: Tree for March 24 (staging/vt66*)
References: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
In-Reply-To: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BAA6BF7.00E5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/10 22:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100323:



(.text+0x5d140): multiple definition of `hostap_set_hostapd'
(.text+0x5ccab): multiple definition of `hostap_ioctl'

when
CONFIG_HOSTAP=y
and
CONFIG_VT665[56]=y

or just both of the latter are =y.

-- 
~Randy
