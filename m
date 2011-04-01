Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1DAXyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:54:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab1DAXyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:54:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.38.2 breaks suspend to disk
Date: Sat, 2 Apr 2011 01:54:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Mike Pagano <mpagano@gentoo.org>
References: <20110330203215.0a1a41a7@xenia.leun.net> <alpine.DEB.2.00.1104011729000.16492@kaball-desktop> <4D961FBC.2030105@zytor.com>
In-Reply-To: <4D961FBC.2030105@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104020154.57136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 01, 2011, H. Peter Anvin wrote:
> On 04/01/2011 11:14 AM, Stefano Stabellini wrote:
> >> Why the heck should we save and restore CR4 only for x86-64?
> > 
> > AFAICT it has always been the case since the beginning of time (Initial
> > git repository build).
> 
> Doesn't change the fact that at least conceptually it's wrong; consider
> bits like NX.  Rafael, do you have any thoughts on this?

I don't seem to remember that being intentional.  I think we should do the
same on both x86s.

Thanks,
Rafael
