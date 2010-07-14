Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0GNCZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:25:08 -0400
Received: from mail.candelatech.com ([208.74.158.172]:48230 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0GNCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:25:07 -0400
Message-ID: <4C3D1FFB.7060705@candelatech.com>
Date: Tue, 13 Jul 2010 19:24:59 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com> <20100713191958.260478c0@virtuousgeek.org>
In-Reply-To: <20100713191958.260478c0@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 07:19 PM, Jesse Barnes wrote:
> On Tue, 13 Jul 2010 18:17:18 -0700

> I thought a related bug was fixed already; the code should be returning
> all zeros for non-existent BAR reads.

The code I pasted was from the exact commit that failed the git bisect.  I didn't
check to see if it was identical later..but it definitely won't boot in 2.6.34
on my system.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
