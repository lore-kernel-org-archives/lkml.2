Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab0JZUwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:52:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52731 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab0JZUwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=m1iEatVsLgBaOrbQtfqv//VDeMonrnnd1+jZ+dahnmIbKbDzWGFFmhH8UfBYNWbeS4
         5ETOM8qBckvEHK5l2rGeM1e5j57XAEJxXC6nGZUySmtqHuPgaIQZGTKOOP37GS03cylJ
         cUnNMQPkCqvs4lBtscAywJDS1TQElDDZddUvM=
Subject: Re: netns patches WAS( Re: [PATCH 8/8] net: Implement socketat.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
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
In-Reply-To: <1287145855.3642.30.camel@bigi>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1bp7oq1u8.fsf@fess.ebiederm.org>  <4C9B162E.7040201@parallels.com>
	 <1285240797.5036.5.camel@bigi>  <4C9B3B06.900@parallels.com>
	 <1285242055.5036.9.camel@bigi> <4C9B3F9C.8080506@parallels.com>
	 <4CA7A07C.5030504@free.fr>  <1286113441.3812.229.camel@bigi>
	 <1287145855.3642.30.camel@bigi>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 16:52:06 -0400
Message-ID: <1288126326.2094.131.camel@mojatatu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

Ping?
If you are too busy to push these in maybe have
someone clueful like Daniel help out submitting? I think it
should probably be reasonable to leave out the sockeat
patch initially if it is deemed controversial..

cheers,
jamal

On Fri, 2010-10-15 at 08:30 -0400, jamal wrote:
> Eric et al,
> 
> Did these patches make it in? I was looking at
> two Davem net trees and i dont see them.
> 
> cheers,
> jamal
> 


