Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab2HIPW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:22:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45529 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab2HIPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:22:57 -0400
Message-ID: <5023D5CF.1070402@wwwdotorg.org>
Date: Thu, 09 Aug 2012 09:22:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 2/3] regulator: add regulator_get_voltage_fixed helper
 op
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org> <1344460727-6243-2-git-send-email-swarren@wwwdotorg.org> <20120809105910.GN24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120809105910.GN24328@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 04:59 AM, Mark Brown wrote:
> On Wed, Aug 08, 2012 at 03:18:46PM -0600, Stephen Warren wrote:
> 
>> Fixed regulators always output desc->min_uV. Add a helper get_voltage
>> op to save duplicating this code in drivers.
> 
> Just use get_voltage_linear() (or convert the existing users).

I don't think there's a *get*_voltage_linear. All the existing
get_voltage "standard" ops require reading a register, hence why I added
this new standard op. I guess I'll look at converting all the existing
users.
