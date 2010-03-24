Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0CXUUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:20:55 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:55179 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0CXUUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:20:53 -0400
Message-ID: <4BAA73D2.1000301@oracle.com>
Date: Wed, 24 Mar 2010 13:19:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 24 (iwlwifi)
References: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
In-Reply-To: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BAA741D.0159:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/10 22:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100323:


drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_good_ack_health':
drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: 'struct iwl_priv' has no member named '_agn'

when CONFIG_IWLAGN is not enabled.



-- 
~Randy
