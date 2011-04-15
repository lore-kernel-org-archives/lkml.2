Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1DONRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:17:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59893 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1DONRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JFqsaWrQaLv10W7WQK9eelXA+WfnWoq67tIwWDL0r3UaPbba740YVm82npo4Kvtr9L
         YZxBNaLgR1ti8l9XpR+lhgt0jAe7uB34XuGRjaH1cbL3jHiTMAWm34tndLtowPNatH+R
         Z/MdzVKXhrvLSE9MYK6MvePBrDlRhR9JXYsVQ=
MIME-Version: 1.0
In-Reply-To: <20110414103254.GC14319@legolas.emea.dhcp.ti.com>
References: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
	<20110414103254.GC14319@legolas.emea.dhcp.ti.com>
Date: Fri, 15 Apr 2011 06:17:51 -0700
Message-ID: <BANLkTinNpMcuk0dpobM1Nu4zeU3yo8QQvw@mail.gmail.com>
Subject: Re: [PATCH] Fixed gpio polarity of gpio USB-phy reset.
From: Steve Sakoman <sakoman@gmail.com>
To: balbi@ti.com
Cc: Juergen Kilb <J.Kilb@phytec.de>, linux-arm-kernel@lists.infradead.org,
        gregkh@suse.de, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 3:32 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Apr 14, 2011 at 09:31:43AM +0200, Juergen Kilb wrote:
>> With commit 19403165 a main part of ehci-omap.c moved to
>> drivers/mfd/omap-usb-host.c created by commit 17cdd29d.
>> Due to this reorganisation the polarity used to reset the
>> external USB phy changed and USB host doesn't recognize
>> any devices.
>>
>> Signed-off-by: Juergen Kilb <J.Kilb@phytec.de>
>
> Judging by how ehci-omap.c was before moving the code:
>
> Acked-by: Felipe Balbi <balbi@ti.com>

This fixes the issue on Overo:

Tested-by: Steve Sakoman <steve@sakoman.com>

Steve
