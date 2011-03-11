Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1CKU3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:29:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1CKU3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:29:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sEbrvyci1JP/4aliCcr+mqJ4/8wF8yBdR5ZRjQTH5mWSe/1BQVa79aUBaf7FVZgHhX
         UHphG+NX26bYRlYUhSFXgkwrd0TpWaCpM86blKQdfHI56eoNi0oxJyibKAHK5Qen2afg
         7b8CldCeR43dOQwka/YTfeth7ZdUCVBcRrotM=
Message-ID: <4D7A84CD.2060401@gmail.com>
Date: Fri, 11 Mar 2011 22:23:41 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110310170143.GA24559@kroah.com> <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com> <20110310171940.GA24972@kroah.com> <4D790A20.3050105@gmail.com> <20110310180959.GA26927@kroah.com> <4D793D05.3070908@gmail.com> <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com> <4D7A72E3.1050407@gmail.com> <20110311193433.GB14204@kroah.com> <4D7A8419.6080107@gmail.com>
In-Reply-To: <4D7A8419.6080107@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 10:20 PM, Nikolai Kondrashov wrote:
> It fails to insert without "force" with the same message. With force it
> installs, but doesn't seem to work, at least for brightness buttons.
Oh, and upon insertion both backlight and WLAN LED turn off and then 
back on again, indeed.

Sincerely,
Nick
