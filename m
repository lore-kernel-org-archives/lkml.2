Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0IWLUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:20:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53372 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0IWLUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=sV8AKtOSB6JhApcO6HF+63L/E+6CKN8Xct2myz8JELITf5Z1CDzTYVAPK0H724nF+g
         VsBRULffAAcYzwQ15cX/X88cktyziK//U1Lq+97ozU81fk5P1q03OKfZL1MjlSu+Zr+L
         PjYc/uzUm5Rw71aQRiWsGLIfrKUNqjJ63LjIg=
Subject: Re: [PATCH 8/8] net: Implement socketat.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@free.fr>,
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
In-Reply-To: <4C9B162E.7040201@parallels.com>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1bp7oq1u8.fsf@fess.ebiederm.org>  <4C9B162E.7040201@parallels.com>
Content-Type: text/plain
Date: Thu, 23 Sep 2010 07:19:57 -0400
Message-Id: <1285240797.5036.5.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 12:56 +0400, Pavel Emelyanov wrote:
> On 09/23/2010 12:51 PM, Eric W. Biederman wrote:
> > 
> > Add a system call for creating sockets in a specified network namespace.
> 
> What for?

I can see many uses if my understanding is correct..
ex, from mother namespace:
fdx = open socket at namespace blah
from mother namespace, read/write/poll fdx 
(eg add route with netlink socket)

cheers,
jamal

