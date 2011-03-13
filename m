Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1CMRuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:50:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48422 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1CMRud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V1Z2/X2/1AtijhuYDl6mW6EYl3OZRyAHaP2BuDOUGRQVYJM62orvVUJj9j8WsxtcWT
         +b70BmFMO+RAxeYvENAlP17p8FMnljzf2wkRwtVbPDAr3V5nHmeEjFki1suVUNetd30D
         UR/JDhRboSbv0fEEbtn8CgtLIUzYgiwWzhYHU=
Message-ID: <4D7D03E6.80900@gmail.com>
Date: Sun, 13 Mar 2011 19:50:30 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110310180959.GA26927@kroah.com> <4D793D05.3070908@gmail.com> <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com> <4D7A72E3.1050407@gmail.com> <20110311193433.GB14204@kroah.com> <4D7A8419.6080107@gmail.com> <20110311203032.GA14384@kroah.com> <4D7C9668.3000902@gmail.com> <20110313161752.GC10718@kroah.com>
In-Reply-To: <20110313161752.GC10718@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 06:17 PM, Greg KH wrote:
> Yes, do not do this, it causes all sorts of problems in the end, not the
> least being the BIOS doesn't know what is going on at all as you are
> changing the brightness without it knowing it.
Sure.
It's just there wasn't any other way before your driver.

Thank you :)

Sincerely,
Nick
