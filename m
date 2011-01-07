Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1AGSCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:02:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53563 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1AGSCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wIO16ftXREjfIk2/bGtogvW9d4x0tWrIJ4/KbIPONQCPlK8DssjaGuRe8jHyxCQKIx
         kLrea3N+tbkJCXGPTyzVT2dW3fo5KhOhWOMGkJK0o6+aGcYlpLbvnxfuX+PF1o77m+fG
         jGK4PMa6kbaW8ls1PB/tU4hoCiktUMmYGV/Ps=
Message-ID: <4D2754F9.8050707@gmail.com>
Date: Fri, 07 Jan 2011 18:01:29 +0000
From: Iain Paton <selsinork@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Michael Chan <mchan@broadcom.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37 vlans on bnx2 not functional, panic with tcpdump
References: <4D2634DE.2060907@gmail.com> <1294357941.21580.2.camel@HP1> <1294361206.21580.7.camel@HP1> <AANLkTi=PGPVRbS3XViskpZ0GSS8ouBcgVZYYG9EoM-Nz@mail.gmail.com> <1294422653.14051.11.camel@HP1>
In-Reply-To: <1294422653.14051.11.camel@HP1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Chan wrote:

> The kernel has undergone major VLAN changes at this time, so there may
> be a problem depending on what stripping mode we're in.  The tg3 driver
> is having some similar problems that haven't been completely resolved
> yet.

It seems to be related to generic vlan changes, I've duplicated it on an Intel 82547L nic in a completely different system connected 
to a different switch.

So you can consider any bnx2 cause for this closed. I'll get back to the list if I can come up with any more useful info.

Thanks for your help,
Iain
