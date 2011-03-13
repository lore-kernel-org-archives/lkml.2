Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1CMNCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 09:02:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57758 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1CMNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 09:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fcpxgqYG5c8/Y3HAwOw40Ii+29gSV0pggUU6MFRo7kPKOEH/xg7uCloNU5u+2e4XKK
         l+foCrrJ15acrYqbGIqxIVqIYUqoGnuBVFcKds2upmWGMyPL4om94bAOqDHAFsOHzeNI
         b7SB6oL1I0RZI9Hg+wxBySAEeIBTe+tG2uvMM=
Message-ID: <4D7CC048.805@gmail.com>
Date: Sun, 13 Mar 2011 15:02:00 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
CC: Greg KH <greg@kroah.com>, Matthew Garrett <mjg@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110310171940.GA24972@kroah.com> <4D790A20.3050105@gmail.com> <20110310180959.GA26927@kroah.com> <4D793D05.3070908@gmail.com> <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com> <4D7A72E3.1050407@gmail.com> <20110311193433.GB14204@kroah.com> <4D7A8419.6080107@gmail.com> <20110311203032.GA14384@kroah.com> <4D7C9668.3000902@gmail.com> <4D7CA2A8.4010700@t-online.de>
In-Reply-To: <4D7CA2A8.4010700@t-online.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 12:55 PM, Richard Schütz wrote:
> That sounds like the driver is interfering with the ACPI video driver.
> Add "acpi_backlight=vendor" to your kernel boot parameters and try again.
Thank you, this helped :)

Greg, is it OK that both 0 and 1 backlight values have the same effect on
brightness?

Thanks.

Sincerely,
Nick
