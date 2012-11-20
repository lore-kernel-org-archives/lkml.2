Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2KTRVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:21:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37062 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2KTRVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:21:44 -0500
Message-ID: <50ABBC24.5000707@wwwdotorg.org>
Date: Tue, 20 Nov 2012 10:21:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        spear-devel@list.st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, andriy.shevchenko@intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] dt: add helper function to read u8 & u16 variables &
 arrays
References: <0ee5b74534a09d75c14b22c2d9330c4971ab30fb.1353386646.git.viresh.kumar@linaro.org>
In-Reply-To: <0ee5b74534a09d75c14b22c2d9330c4971ab30fb.1353386646.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 09:45 PM, Viresh Kumar wrote:
> This adds following helper routines:
> - of_property_read_u8_array()
> - of_property_read_u16_array()
> - of_property_read_u8()
> - of_property_read_u16()
> 
> This expects arrays from DT to be passed as:
> - u8 array:
> 	property = /bits/ 8 <0x50 0x60 0x70>;
> - u16 array:
> 	property = /bits/ 16 <0x5000 0x6000 0x7000>;

Reviewed-by: Stephen Warren <swarren@nvidia.com>

