Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1DKRG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:06:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58397 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1DKRG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:06:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VcGgncH7KEkrs2hJUz2PxOW7KY8dSfqbd8BvITIaYgNC4Q5gbPJAAkdkSeKNLAa/wX
         0u79yekWEj/6aMV4pLYylKCZehAzQhkvF4P17eqFeFsfA0K7QMC+M/GS+GTBPW3gSHt0
         lLh78rcg9vG0XmCRxFwYYDb9STsSJhwIQLq8U=
Message-ID: <4DA3350E.2060400@gmail.com>
Date: Mon, 11 Apr 2011 10:06:22 -0700
From: Steve Calfee <stevecalfee@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Regression?] Removed regulator support in ehci-omap
References: <20110411093214.GA18215@rainbow>
In-Reply-To: <20110411093214.GA18215@rainbow>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 02:32, Dmitry Artamonow wrote:
> Hi, guys!
> 
> Can anyone explain why regulator support has been removed from ehci-omap
> driver in commit 19403165 ("usb: host: omap: ehci and ohci simplification")[1]?
> In 2.6.37/2.6.38 it was enough to apply simple patch[2] adding regulators
> description to board file to make USB work on omap3evm board (because USB PHY
> is powered via regulator). But now it won't work anymore in 2.6.39-rc2.
> BTW, I suspect that this commit also broke USB on omap3pandora board, as it
> defines "hsusb0" regulator supply in its board file:
> 
Yes, And Beagleboard xm (and I suspect other beagleboard versions) has
been broken in 2.6.39rc1+.

Regards, Steve
