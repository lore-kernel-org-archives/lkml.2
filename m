Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2BINE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:04:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57691 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756464Ab2BINE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:04:27 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/CpqRngRPCijYS1faBp65D2jzj8UPAMIB4N9WJHh
	tX/0+wIuZezKK/
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: swap storm since kernel 3.2.x
Date: Thu, 9 Feb 2012 14:04:21 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.20; KDE/4.8.0; i686; ; )
Cc: Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org
References: <201202041109.53003.toralf.foerster@gmx.de> <CAJd=RBDbYA4xZRikGtHJvKESdiSE-B4OucZ6vQ+tHCi+hG2+aw@mail.gmail.com> <20120209113606.GA8054@sig21.net>
In-Reply-To: <20120209113606.GA8054@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202091404.22470.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Johannes Stezenbach wrote at 12:36:06
> On Wed, Feb 08, 2012 at 08:34:14PM +0800, Hillf Danton wrote:
> > And I want to ask kswapd to do less work, the attached diff is
> > based on 3.2.5, mind to test it with CONFIG_DEBUG_OBJECTS enabled?
> 
> Sorry, for slow reply.  The patch does not apply to 3.2.4
> (3.2.5 only has the ASPM change which I don't want to
> try atm).  Is the patch below correct?
> 
confirmed - doesn't apply here too :-(

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
