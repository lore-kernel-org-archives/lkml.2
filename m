Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0IWLlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:41:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63476 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab0IWLlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=iqMGQ7q3TSLtnYN0ltxCwfeJLoCdlbz9e0z2NZhXrqOPX/M6QuHXvVlNx67BPIcVqm
         qyF/af15l/NTuka3BLecZ20FNHqBAG9pkkY362PVYQPr69oHf3hM1UoMiAFgC3brG4W5
         14Li9ALFXQDq4apMcPOqRhmLX8k8lYBWYlxmE=
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
In-Reply-To: <4C9B3B06.900@parallels.com>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1bp7oq1u8.fsf@fess.ebiederm.org>  <4C9B162E.7040201@parallels.com>
	 <1285240797.5036.5.camel@bigi>  <4C9B3B06.900@parallels.com>
Content-Type: text/plain
Date: Thu, 23 Sep 2010 07:40:55 -0400
Message-Id: <1285242055.5036.9.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 15:33 +0400, Pavel Emelyanov wrote:

> This particular usecase is unneeded once you have the "enter" ability.

Is that cheaper from a syscall count/cost?
i.e do I have to enter every time i want to write/read this fd?
How does poll/select work in that enter scenario?

cheers,
jamal

