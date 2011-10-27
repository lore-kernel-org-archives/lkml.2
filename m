Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1J0Ud3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:33:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36399 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab1J0Ud2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:33:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: maciej.rutecki@gmail.com
Subject: Re: regression tracking
Date: Thu, 27 Oct 2011 22:35:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, Florian Mickler <florian@mickler.org>,
        linux-kernel@vger.kernel.org
References: <CAErSpo4REhcp_SgDyUTbi8jw9_8317Zi1duo1fTihB8x=drtuw@mail.gmail.com> <201110262013.55562.maciej.rutecki@gmail.com>
In-Reply-To: <201110262013.55562.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110272235.59240.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 26, 2011, Maciej Rutecki wrote:
> Hi
> 
> On środa, 26 października 2011 o 19:23:11 Bjorn Helgaas wrote:
> > The regression tracking that you folks used to do before the demise of
> > bugzilla.kernel.org was incredibly valuable.
> > 
> > I'm very concerned about the fact that we don't have a systematic way
> > to do this any more.  Some things do get reported on LKML, of course,
> > but without the legwork you guys did, I'm afraid we're just dropping
> > things on the floor because there's no summary of what the issues are,
> > how many people are seeing them, who's responsible, etc.
> > 
> > Consider this as (1) kudos for performing an essential community
> > service, and (2) a plea for the resurrection or replacement of
> > bugzilla.kernel.org or some other mechanism for reviving regression
> > tracking.
> 
> Because bugzilla is still down, I yesterday started send regressions (found in 
> LKML) report directly to Rafael, to create summary report (etc.) of them. 
> Until bugzilla comes back, we plan to collect regression in this way, but any 
> proposal for a better solution is welcome.

Seconded.

Especially if there's a password-protected Wiki service somewhere that we
could use to store data temporarily until the BZ is back, it would be much
appreciated.

Thanks,
Rafael
