Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0KPUii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:38:38 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36373 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab0KPUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:38:36 -0500
X-Auth-Info: vvr0kFFTDxlQkVCA2RRsu6L2uQPSe6yH67gzOjspoMU=
Message-ID: <4CE2EC13.9090707@grandegger.com>
Date: Tue, 16 Nov 2010 21:39:47 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tomoya-linux@dsn.okisemi.com, andrew.chih.howe.khor@intel.com,
        masa-korg@dsn.okisemi.com, sameo@linux.intel.com,
        margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, joel.clark@intel.com, yong.y.wang@intel.com,
        chripell@fsfe.org, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v4] can: Topcliff: PCH_CAN driver: Add	Flow
 control/Fix Endianess issue/Separate IF register/Enumerate LEC	macro/Move
 MSI processing/Use BIT(X)/Change Message Object index/Add	prefix PCH_
References: <4CE275A4.9010400@dsn.okisemi.com> <20101116.091443.226753420.davem@davemloft.net>
In-Reply-To: <20101116.091443.226753420.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 11/16/2010 06:14 PM, David Miller wrote:
> 
> Way too many changes in one patch.
> 
> Please post one that fixes the endianness issues.
> 
> One that fixes the register interface seperation.
> 
> One that adds flow control processing.
> 
> etc.
> 
> When you combine many tasks into one patch it's impossible
> to bisect through your changes to debug problems in order
> to figure out which changed introduced a bug.
> 
> I am not applying this, and I will not apply your patches
> until you split them up properly.
> 
> You may think that there is zero value in this, but there
> is huge value in it for anyone who tries to debug your
> changes in the future.  Right now you are making that a
> nearly impossible task.

Please take into account that this patch got accepted by accident
(because the maintainer did not respond properly in time). At that time
the driver was incomplete, not ready for mainline and did not even work
properly. Therefore it makes little sense to debug or even bisec these
changes. Just for that reason I made an exemption and added my
"Acked-by". Hope you can share my arguments.

Wolfgang.

