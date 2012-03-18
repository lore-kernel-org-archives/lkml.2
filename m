Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2CRMR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 08:17:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50866 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab2CRMR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 08:17:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Date: Sun, 18 Mar 2012 13:21:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203180129.38469.rjw@sisk.pl> <CA+55aFzrj32d6ROrtSOBn_HgW5m8Nf5ZhF7H6fRfoPwkX=A8-w@mail.gmail.com>
In-Reply-To: <CA+55aFzrj32d6ROrtSOBn_HgW5m8Nf5ZhF7H6fRfoPwkX=A8-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203181321.38852.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 18, 2012, Linus Torvalds wrote:
> On Sat, Mar 17, 2012 at 5:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > The patch below (untested) goes slightly into that direction, although not as
> > far as to modify fw_create_instance().  It does, however, split
> > _request_firmware() into "prepare", "load" and "cleanup" parts and moves
> > the usermodehelper check along with the read-locking of umhelper_sem down
> > to the callers, ie. request_firmware() and request_firmware_work_func().
> 
> Looks fairly reasonable to me from a quick read-through, and the code
> seems to make sense.

Thanks!

I'll split it into a series of patches, then, and post for testing.

Rafael
