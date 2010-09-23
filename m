Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0IWLWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:22:13 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53586 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0IWLWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=dy/huysQ4g3YLT97DUbofMagWs/b9cW9XceSVxzc8iZcya8p9KvdsN1iVVyLcHhbqF
         AWGmZEkR0lBldNLmufj9La865KdWVmWIonfcBgeieCFvb7Wr36pwE4WfUgePOHUTqq67
         CUk6YKnviH/+l9NDxkdhdGL9mcv4RnkkT9nYY=
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <m1hbhgq1v1.fsf@fess.ebiederm.org>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1hbhgq1v1.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Thu, 23 Sep 2010 07:22:06 -0400
Message-Id: <1285240926.5036.7.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 01:51 -0700, Eric W. Biederman wrote:
> Take advantage of the new abstraction and allow network devices
> to be placed in any network namespace that we have a fd to talk
> about.
> 

So ... why just netdevice? could you allow migration of other
net "items" eg a route table since they are all tagged by
netns?

cheers,
jamal

