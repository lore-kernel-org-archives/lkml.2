Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1JLQxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:53:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:47685 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JLQw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:52:59 -0400
Message-ID: <4E95C5E2.4020607@atmel.com>
Date: Wed, 12 Oct 2011 18:52:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] dmaengine: at_hdmac: platform data move to use .id_table
References: <1314075338.22120.3.camel@vkoul-udesk3> <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com> <1318342612.1546.352.camel@vkoul-udesk3> <4E95C1AF.5080803@atmel.com>
In-Reply-To: <4E95C1AF.5080803@atmel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 06:34 PM, Nicolas Ferre :
> On 10/11/2011 04:16 PM, Vinod Koul :

[..]

>> Little confused at this, where is the remove of existing platfrom data
>> per the changelog?
> 
> Well, yes, it is the use of platform data that is removed, not the
> structure it self. I change the log message in my v2 patch series.

v3 actually...

Bye,
-- 
Nicolas Ferre
