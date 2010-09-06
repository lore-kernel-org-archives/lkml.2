Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0IFKan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:30:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59127 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0IFKam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i7/PRri3VCtdbiGJ+IQjFaoakA8tWO+I0+TVzLKbZRfWLr1Io0BDDfvUcx9TpkrVqd
         iBUMtfG4LyaZ/nRMJAbq4m8j3YNM8nmBKSA6wY51eX2vwBC0vGzy7MutwJEi5wxEwezp
         La9zqcwW+fFJcRZ8wDgNOkUabIT2iKHFM/ys0=
Message-ID: <4C84C2CE.4080905@gmail.com>
Date: Mon, 06 Sep 2010 06:30:38 -0400
From: Doug Nazar <nazard.lkml@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        paulmck@linux.vnet.ibm.com
Subject: Re: [Bug #17131] WARN with 3c905 boomerang NIC
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>	<4AUWBNzTkbD.A.V3H.2FueMB@chimera> <20100906075007.5797f524@schatten.dmk.lab>
In-Reply-To: <20100906075007.5797f524@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 2010-09-06 1:50 AM, Florian Mickler wrote:
>
> Paul provided a patch at
> https://bugzilla.kernel.org/attachment.cgi?id=28832 .
>
> Has he pinged you already about it? You are not subscribed to the bug
> and I didn't see anything on the netdev mailinglist or lkml.
>

Sorry, kinda ignored this one once David said it was being worked on. 
I've been busy trying to track down why my wireless isn't working.

For the record, neither Paul's patch (095d05: softirq: adjust error 
check) or Ben's (24cd80: 
3c59x: Remove incorrect locking; correct documented lock hierarchy) 
which is sitting in the net-2.6 fix the issue. Tested atop 2bfc96a 
(Linux 2.6.36-rc3)

It seems to be an init issue as it only happens once during boot and 
doesn't impact functionality.

Doug

