Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1CMRv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:51:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61428 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1CMRvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rLI0UfL71AuZAnkJSol+e5qppaKFvisQfuSNBwoV8vN7LSa8hBL30FfchgsCfrmkbW
         iddqDeRTLCdnGWqr+OI+58aPihqkgE3ix1y92Vz1HpVzXysJedrOEzAo4nBojQez/G/H
         ULICmZLsXcxn5mYP0vTnd12pd383PsUZki6s8=
Message-ID: <4D7D0438.9060607@gmail.com>
Date: Sun, 13 Mar 2011 19:51:52 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Greg KH <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <4D793D05.3070908@gmail.com> <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com> <4D7A72E3.1050407@gmail.com> <20110311193433.GB14204@kroah.com> <4D7A8419.6080107@gmail.com> <20110311203032.GA14384@kroah.com> <4D7C9668.3000902@gmail.com> <20110313161752.GC10718@kroah.com> <20110313162812.GA25369@srcf.ucam.org>
In-Reply-To: <20110313162812.GA25369@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 06:28 PM, Matthew Garrett wrote:
> It's also modifying configuration that belongs to a device being managed
> by another driver, so it's the kind of thing we frown upon.
Sure, then I guessed right.

> Having said that, the Intel driver should gain native backlight support in
> .39.
Great news!

Thank you :)

Sincerely,
Nick
