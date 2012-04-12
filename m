Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897Ab2DLC6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:58:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52507 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279Ab2DLC6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:58:16 -0400
Message-ID: <4F8644B7.1010705@ti.com>
Date: Wed, 11 Apr 2012 19:57:59 -0700
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <mgreer@animalcreek.com>, <msalter@redhat.com>,
        <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
References: <1331934707-29487-1-git-send-email-aneesh@ti.com> <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 04/11/2012 07:44 PM, Paul Walmsley wrote:
> Cc Mark Greer, Mark Salter
>
> Hi Greg, Aneesh,
>
> On Sat, 17 Mar 2012, Aneesh V wrote:
>
>> Add a driver for the EMIF SDRAM controller used in TI SoCs
>>
>> EMIF is an SDRAM controller that supports, based on its revision,
>> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
>> for LPDDR2.
>
> Just checking to see what the current state of this series is.  Greg, are
> you considering this for merging, or are there remaining issues?  Aneesh,
> do you have any remaining issues to resolve with this set?

No. I don't have anything remaining. It's just that I was on vacation
for a while and couldn't find time for this after that. If Greg is fine
with this, I can rebase it and send one final version with
Reviewed-By's from Santosh and Benoit.

thanks,
Aneesh
