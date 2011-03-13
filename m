Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1CMRtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:49:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33542 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1CMRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=opIMkiy4mXisKi/6asc0yXDcx68wIYGARRM6syRR2f/N/WDpPDGnEezArscJvgJSqz
         ncGeDK739BzuU7Aov/ikGJkQXSPaReE5V6eJai7PHMM+WXRdrELWtIF50YkKUWzu+eVW
         eCl1wVcUUhayLm/XR/GQlcnQ/e82H4IO/CzRY=
Message-ID: <4D7D0390.3000108@gmail.com>
Date: Sun, 13 Mar 2011 19:49:04 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>,
        Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com> <4D7A72E3.1050407@gmail.com> <20110311193433.GB14204@kroah.com> <4D7A8419.6080107@gmail.com> <20110311203032.GA14384@kroah.com> <4D7C9668.3000902@gmail.com> <4D7CA2A8.4010700@t-online.de> <4D7CC048.805@gmail.com> <20110313161823.GD10718@kroah.com>
In-Reply-To: <20110313161823.GD10718@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 06:18 PM, Greg KH wrote:
> I really don't know, sorry.  Try messing with the actual_brightness file
> instead, that's the one to use.
Sure, thank you :)

Still, what about the wireless on/off button? Is Gnome support required, or
it should work as is? Because mine doesn't seem to do anything.

Thanks.

Sincerely,
Nick
