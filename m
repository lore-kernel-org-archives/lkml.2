Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab1JOVWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:22:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14260 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1JOVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:22:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:
	content-id:x-system-of-record;
	b=nteubFDXMOkfrtrcA9m32bb5oPXFsykWxyvsBQB4fQ8094lUxCccPjWAte5yWKCiP
	hYPenF0Xdj+7Rh9e0Rp4Q==
Date: Sat, 15 Oct 2011 14:21:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
cc: werner <w.landgraf@ru.ru>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        ilw@linux.intel.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
In-Reply-To: <201110152119.58509.toralf.foerster@gmx.de>
Message-ID: <alpine.DEB.2.00.1110151416360.15894@chino.kir.corp.google.com>
References: <201110152119.58509.toralf.foerster@gmx.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-252661854-1318713541=:15894"
Content-ID: <alpine.DEB.2.00.1110151419090.15894@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-252661854-1318713541=:15894
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1110151419091.15894@chino.kir.corp.google.com>

On Sat, 15 Oct 2011, Toralf Förster wrote:

> With a ThinkPad T400 with "Intel Corporation PRO/Wireless 5100 AGN [Shiloh] 
> Network Connection" I experienced few times in the last week that the suddenly 
> the network stops to work - no messages in /var/log/messages nor any other 
> outout. Only  a restart of the network services helped
> 
> n22 ~ # uname -a
> Linux n22 3.1.0-rc9+ #1 SMP Fri Oct 14 19:21:56 CEST 2011 i686 Intel(R) 
> Core(TM)2 Duo CPU P8600 @ 2.40GHz GenuineIntel GNU/Linux
> 
> It is an almost stable Gentoo.
> 
> Anybody else made similar experiences ?
> 

It looks like werner is reporting a similar problem in 
https://lkml.org/lkml/2011/10/15/67 but with a different laptop, 
information is vague in that regression report.

Adding him, Wey-Yi Guy from Intel, and linux-wireless mailing list to the 
cc.

What's the last kernel prior to 3.1-rc9 that worked for you?

What does "iwconfig" show?

What does "dmesg | grep iwlagn" show?
--397155492-252661854-1318713541=:15894--
