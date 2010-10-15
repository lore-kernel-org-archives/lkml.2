Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0JOMbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:31:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40128 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0JOMbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=pAZT0uWSijInAKGasMyIgnvg73RFYDcZEdRxUY/cWp1cwxstRdjWtsgJuUaYGE0bGQ
         VekcqVK0XAS6V6guUPimyi+wREboAUxe/rB9hedK45SlvYXjLhapGe7EsoAZswpWSROe
         hGjp3jrD6Hm4VLckA9Vf+2FAUv4Aii1WAgt5g=
Subject: netns patches WAS( Re: [PATCH 8/8] net: Implement socketat.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Daniel Lezcano <daniel.lezcano@free.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <1286113441.3812.229.camel@bigi>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1bp7oq1u8.fsf@fess.ebiederm.org>  <4C9B162E.7040201@parallels.com>
	 <1285240797.5036.5.camel@bigi>  <4C9B3B06.900@parallels.com>
	 <1285242055.5036.9.camel@bigi> <4C9B3F9C.8080506@parallels.com>
	 <4CA7A07C.5030504@free.fr>  <1286113441.3812.229.camel@bigi>
Content-Type: text/plain
Date: Fri, 15 Oct 2010 08:30:55 -0400
Message-Id: <1287145855.3642.30.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric et al,

Did these patches make it in? I was looking at
two Davem net trees and i dont see them.

cheers,
jamal

