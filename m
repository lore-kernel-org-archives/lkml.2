Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1DIJve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 05:51:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63178 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1DIJvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 05:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=a6dX8/Yp0Hz+gxK87jLAGvxQ3Wnh40DfIbsUQglNKef9SidiE8tCCzpuBF4WtUsc8R
         uKRsQOk2EyEWtZ0CQ0exaSjet0mSJYC3O4taUrkEtWv9ZRuJQUpVTO+rks0+dat92BZS
         G1i3pB7V4YC+SAUUbZnnEvbNN5fQoWUr8X5jg=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: 2.6.39-rc2 on zaurus: does not build, does not boot
Date: Sat, 9 Apr 2011 12:49:58 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.38-gentoo-anarsoul; KDE/4.6.2; i686; ; )
Cc: Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, thommycheck@gmail.com,
        dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
        kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
        lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
        eric.y.miao@gmail.com, zaurus-devel@www.linuxtogo.org
References: <20110408062646.GA1472@ucw.cz> <201104080931.11202.marek.vasut@gmail.com>
In-Reply-To: <201104080931.11202.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104091249.59159.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 April 2011 10:31:10 Marek Vasut wrote:
> On Friday 08 April 2011 08:26:46 Pavel Machek wrote:
> > Hi!
> > 
> > Build fix is below. Maybe it is pending in the trees somewhere
> > already...
> 
> Fix is already there, it was broken by a patch from someone recently.
> Thanks though

I broke it accidently, sorry :) you can enable CONFIG_FB_PXA_OVERLAY as 
temporary workaround

Regards
Vasily
