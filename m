Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1JRGHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:07:31 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51670 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab1JRGHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:07:30 -0400
MIME-Version: 1.0
In-Reply-To: <20111013173204.GL28290@legolas.emea.dhcp.ti.com>
References: <1318319609-20522-1-git-send-email-keshava_mgowda@ti.com>
	<20111013173204.GL28290@legolas.emea.dhcp.ti.com>
Date: Tue, 18 Oct 2011 11:37:28 +0530
Message-ID: <CAP05o4K6RS5YawJ8POy7ZifJ7W8MRA0d77iwjZZ1ojTQnQS=nA@mail.gmail.com>
Subject: Re: [PATCH v14] mfd: omap: usb: Runtime PM support
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: balbi@ti.com, sameo@linux.intel.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, khilman@ti.com, b-cousson@ti.com,
        paul@pwsan.com, gadiyar@ti.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 11, 2011 at 01:23:29PM +0530, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The usbhs core driver does not enable/disable the interface and
>> functional clocks directly, These clocks are handled by runtime pm,
>> hence instead of the clock enable/disable, the runtime pm APIS are
>> used. however,the optional clocks and port clocks are handled by
>> the usbhs core.
>>
>> Dependency:
>> This patch is dependent on this series:
>> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation
>> for EHCI and OHCI drivers.
>>
>> Validation performed:
>> The global suspend/resume of EHCI and OHCI is validated on
>> OMAP3430 sdp board with this patch combined with the series:
>> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation
>> for EHCI and OHCI drivers.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> Reviewed-by: Kevin Hilman <khilman@ti.com>
>> Reviewed-by: Partha Basak <parthab@india.ti.com>
>


Hi Sameo
        The prior series of this patch is acked by balbi , paul ,
benoit and kevin.
I request if you think everything is OK in this patch please ack ;
otherwise if you have any review comment I have to close them ASAP.

Thanks and Regards
keshava
