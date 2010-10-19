Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0JSOdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:33:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38158 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0JSOdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SiKHZOzj5ldRiFoV4CPocTnnyFdvqXYRoD30qehQ3igXwV8g7tHS5OEO5dW+zlo2h1
         B233dmmhMRZKWdnpqxmWiYOPgPIhTL4MAjHk+7Pa4HoL3HwfPmg7W91IxO33UiIHYPV5
         c5z2YnKsDMJISPqBX9C65umfD+CR6qr6x445w=
MIME-Version: 1.0
In-Reply-To: <4CBD9FD5.506@nokia.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<4CBD9FD5.506@nokia.com>
Date: Tue, 19 Oct 2010 17:33:50 +0300
Message-ID: <AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Tue, Oct 19, 2010 at 4:40 PM, Roger Quadros <roger.quadros@nokia.com> wrote:
>> @@ -843,6 +841,7 @@ config USB_CDC_COMPOSITE
>>  config USB_G_NOKIA
>>        tristate "Nokia composite gadget"
>>        depends on PHONET
>> +       depends on USB_GADGET_MUSB_HDRC
>
> This is wrong. Is there a build problem or run-time problem without this?

Try:
CONFIG_USB_G_NOKIA=y
CONFIG_USB_GADGET_MUSB_HDRC=n

At least g_nokia doesn't seem to work correctly on my N900.

-- 
Felipe Contreras
