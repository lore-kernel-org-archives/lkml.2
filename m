Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2JBHQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:16:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40275 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab2JBHQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:16:43 -0400
Message-ID: <506A94C0.1010106@ti.com>
Date: Tue, 2 Oct 2012 12:46:16 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "Philip, Avinash" <avinashphilip@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <gururaja.hebbar@ti.com>
Subject: Re: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support
 for APWM driver
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com> <1348658863-29428-2-git-send-email-avinashphilip@ti.com> <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 10/2/2012 11:30 AM, Thierry Reding wrote:
> On Wed, Sep 26, 2012 at 04:57:42PM +0530, Philip, Avinash wrote:
> [...]
>> +#include <linux/platform_data/ti-pwmss.h>
> [...]
>> +static struct pwmss_platform_data am33xx_data = {
>> +	.has_configspace	= true,
>> +};
> 
> This structure is defined in a public header. I don't see why it has to,
> given that it's only used to associate some data with an of_device_id
> entry below. Since AM33xx never had anything but OF support in the
> mainline kernel I don't think we should add platform data.

Avinash probably introduced platform data because the same PWM IP is
used in older DaVinci family SoCs (DA830 and DA850) which are not
converted to DT. There are existing boards for those SoCs  (supported in
mainline) which could benefit from this driver.

Thanks,
Sekhar
