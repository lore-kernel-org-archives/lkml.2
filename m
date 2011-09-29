Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab1I2XeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:34:04 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:39460 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab1I2Xd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:33:59 -0400
Date: Thu, 29 Sep 2011 19:31:41 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <d089f3ec-ccfc-4350-bd11-b8ccadf4ad3a@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110929190855.GA5381@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.231.143]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Sorry, I ment Linus's tree, that's where it matters for the stable
> releases.

The patch in question hasn't hit Linus' tree yet, but it's queued up in Stephen Rothwell's for-next tree.  As I understand it, Andrew's tree gets fed into that on a somewhat regular basis, and Andrew took my four patches (plus a patchcheck fixup he committed) already.  So, I pulled Stephen's for-next, put my patches plus the patchcheck fix on top, then wrote a fixup patch that fixes what I saw as being wrong in the patch in question.

> Ok, care to get the patch into Linus's tree and then I can take it
> into
> stable?

I made a new patch that fixes the patch I NAKed.  My entire patch set can be applied on top of his now (I was wrong about them conflicting, I think there was just enough space for the context not to overlap in a way that would conflict as I thought it would).  So, since the change isn't life threatening or anything, and can be easily fixed up, I'll withdraw my NAK and just submit the additional patch to correct it once I get home and have access to a mail program that does something besides attachments or mangled text as the only patch sending options.

Now, the question of whether or not you want a patch in -stable that hasn't hit Linus' tree yet is up to you...

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

