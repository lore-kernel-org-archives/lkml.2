Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab1JZSOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:14:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38370 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab1JZSOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:14:01 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: regression tracking
Date: Wed, 26 Oct 2011 20:13:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Florian Mickler <florian@mickler.org>,
        linux-kernel@vger.kernel.org
References: <CAErSpo4REhcp_SgDyUTbi8jw9_8317Zi1duo1fTihB8x=drtuw@mail.gmail.com>
In-Reply-To: <CAErSpo4REhcp_SgDyUTbi8jw9_8317Zi1duo1fTihB8x=drtuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110262013.55562.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On środa, 26 października 2011 o 19:23:11 Bjorn Helgaas wrote:
> The regression tracking that you folks used to do before the demise of
> bugzilla.kernel.org was incredibly valuable.
> 
> I'm very concerned about the fact that we don't have a systematic way
> to do this any more.  Some things do get reported on LKML, of course,
> but without the legwork you guys did, I'm afraid we're just dropping
> things on the floor because there's no summary of what the issues are,
> how many people are seeing them, who's responsible, etc.
> 
> Consider this as (1) kudos for performing an essential community
> service, and (2) a plea for the resurrection or replacement of
> bugzilla.kernel.org or some other mechanism for reviving regression
> tracking.

Because bugzilla is still down, I yesterday started send regressions (found in 
LKML) report directly to Rafael, to create summary report (etc.) of them. 
Until bugzilla comes back, we plan to collect regression in this way, but any 
proposal for a better solution is welcome.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
