Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1I3B43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:56:29 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47918 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1I3B42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:56:28 -0400
Date: Thu, 29 Sep 2011 21:54:12 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <3742f425-ad48-4496-8281-5c76eda8b1af@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110929233902.GA5969@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.113.99]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Sorry, I can't do that, it's against the rules for -stable (see
> Documentation/stable_kernel_rules.txt).
> 
> Just get your patch into Linus's tree soon, and all should be good,
> right?

Actually, I wasn't referring to mine, I was referring to the one I NAKed
when I was still under the (mistaken) impression that it was only in
for-next and not in Linus' tree.

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

