Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0CRR1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:27:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38008 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0CRR1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <4BA24DA8.9030309@scram.de>
References: <20100318144836.21082.93040.stgit@angua> <20100318152238.21082.10985.stgit@angua> 
	<4BA24DA8.9030309@scram.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 18 Mar 2010 10:24:05 -0600
X-Google-Sender-Auth: 25cb150a80c75dce
Message-ID: <fa686aa41003180924x1b6de684w7267013afd07496@mail.gmail.com>
Subject: Re: [V2 PATCH 06/10] of/drivers: Always use struct device.of_node to 
	get node pointer
To: Jochen Friedrich <jochen@scram.de>
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 9:58 AM, Jochen Friedrich <jochen@scram.de> wrote:
> Hi Grant,
>
>> The following structure elements duplicate the information in
>> 'struct device.of_node' and so are being eliminated.  This patches
>> makes all readers of the following elements use device.of_node instead.
>>
>> struct dev_archdata.prom_node (sparc)
>> struct dev_archdata.of_node (powerpc)
>> struct of_device.node
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>>  drivers/i2c/busses/i2c-ibm_iic.c              |    4 ++--
>>  drivers/i2c/busses/i2c-mpc.c                  |   17 ++++++++-------
>
> drivers/i2c/busses/i2c-cpm.c is missing in this patch.

Good catch, Thanks.

g.
