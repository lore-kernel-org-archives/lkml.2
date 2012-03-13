Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792Ab2CMVjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:39:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41683 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761Ab2CMVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:39:17 -0400
Message-ID: <4F5FBE82.70501@gmail.com>
Date: Tue, 13 Mar 2012 14:39:14 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] usb: Don't make USB_ARCH_HAS_OHCI and USB_ARCH_HAS_EHCI
 depend on USB_SUPPORT.
References: <1331578904-15561-1-git-send-email-ddaney.cavm@gmail.com> <20120313211758.GA10168@kroah.com>
In-Reply-To: <20120313211758.GA10168@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 02:17 PM, Greg Kroah-Hartman wrote:
> On Mon, Mar 12, 2012 at 12:01:44PM -0700, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> The fact that an architecture/board has OHCI or EHCI does not depend on
>> the fact that the kernel is configured with USB_SUPPORT.
>
> Why are you ignoring XHCI here as well?

Because it was not failing for my specific configuration.

>  Shouldn't that fall under the
> same rules as OHCI and EHCI (hint, they should...)

OK, makes sense, I will change it to do that too.

New patch soon...

David Daney
