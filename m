Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110Ab0GTPBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:01:39 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:34921 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758194Ab0GTPBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:01:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 459147.91989.bm@omp118.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pK1rmKGn8kPdFiZKu3I6LIvFfda0TBzdo3hU1pFQTi9zya/f9MlFfDYTosJJVqV5tbZnefmfrepspKIh4dy+wx5nryn+IvlcH1Rzh/AYfVQnaN5p6/yMfPtL940wKabZ+NLoIZzbe83TQX2yg92eTlmPVpYCkbAfRjv5jNeLI1E=;
Message-ID: <289287.8629.qm@web180303.mail.gq1.yahoo.com>
X-YMail-OSG: W4r0niEVM1mx6cluq45rWUGUcDPGdNyOtD_IxZaTWO7xxSs
 BfuomCYh.BhLdQC_AKYvg9I7_W1141lJhqmQ0.n_gV567WDU_c.CuXS9Ub8s
 d2XtOYcfAEeQJ6.OVvze9BzYbs33WG333JZsBN.kvwponWfMOh4yi4sL2Lpb
 XmwqKw96XCocp_dF5wZnEjpXZS4k0lkuEdWfJL4zBFhqIF.ZvcbSjMojfoW_
 B3pUkyhQw7RpN6bzDC37vg8q82soyRbQEFpN2fSMnSL5AvAKmaCDg5ZPnL2T
 B8CINrcgfa2gw0VP6GJXP5Ghpr_fr7di12XupKIKyNxm1EL7ATPgtEQ--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Tue, 20 Jul 2010 08:01:37 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
To: Alan Stern <stern@rowland.harvard.edu>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
In-Reply-To: <op.vf4vrwa67p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 7/20/10, Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:

> > Plus, you seem to be overlooking the basic need
> > (for userspace) to manage these IDs so they're
> > properly unique.  Two gadgets should never end
> up
> > using the same serial number.
> 
> I'm not overlooking that.  I simply consider that a
> separate issue.
> Driver should provide some kind of default

It can't do that and guarantee uniqueness.
(Unless you consult the random number system,
which may not be available that early, and is
in any case not appropriate for this task.

Your concept is (still/again) broken.

 (just like File
> Storage
> Gadget) and the fact that user space should
> override it is another
> matter in my opinion.

The value must come from userspace in the first
place, else it can't be correctly managed!!

> 

