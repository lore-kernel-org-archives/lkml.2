Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0IMSAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:00:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51044 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0IMSAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:00:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #16961] kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
Date: Mon, 13 Sep 2010 19:59:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, Avi Kivity <avi@redhat.com>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera> <0c5PAlgnPrH.A.WOC.hsRjMB@chimera> <20100913134847.GA5263@swordfish.minsk.epam.com>
In-Reply-To: <20100913134847.GA5263@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131959.26660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 13, 2010, Sergey Senozhatsky wrote:
> On (09/12/10 20:14), Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16961
> > Subject		: kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
> > Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Date		: 2010-08-19 9:54 (25 days old)
> > Message-ID	: <<20100819095429.GA5201@swordfish.minsk.epam.com>>
> > References	: http://marc.info/?l=linux-kernel&m=128221169606214&w=2
> > Handled-By	: Avi Kivity <avi@redhat.com>
> > 
> > 
> 
> Hello,
> Fixed by
> commit da908f2fb4e783c2a4de751fb90f11a0dd041161
> Author: Zachary Amsden <zamsden@redhat.com>

Thanks, closing.

Rafael
