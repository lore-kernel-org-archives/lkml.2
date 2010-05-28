Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab0E1CJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:09:45 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:48646 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0E1CJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=GB5EPtlYYocY99XDtr1GW/Yc0uUpu07Bf9IliTuiqPD26BwM6bK3uPbNZY2xQ7TS68
         j4641aP7NOLs/Zy22kx9399pC7A3zaKJfMQl3S0RlBnJm/Ac4qKbyKHtT0ljL7lHBf4e
         hsmGRznrgSCAJi6omRC08KA+OQm9bZBgrhsyQ=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Florian Mickler <florian@mickler.org>, Vitaly Wool <vitalywool@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100526142430.327ccbc4@schatten.dmk.lab>
References: <1274482015-30899-1-git-send-email-arve@android.com> <201005242049.18920.rjw@sisk.pl> <87wrusvrqe.fsf@deeprootsystems.com> <201005250138.16293.rjw@sisk.pl> <1274863655.5882.4875.camel@twins> <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com> <1274867106.5882.5090.camel@twins> <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Thu, 27 May 2010 22:09:37 -0400
Message-ID: <877hmon5em.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 14:24:30 +0200, Florian Mickler <florian@mickler.org> wrote:
> Because he is using a robust kernel that provides suspend blockers and
> is preventing the vampire from sucking power? 
> 
Suspend blockers are only a flawed and indirect way to keep the vampire
from sucking.

> Most users don't even grasp the simple concept of different "programs".
> They just have a device and click here and there and are happy. 
> 
> Really, what are you getting at? Do you deny that there are programs,
> that prevent a device from sleeping? (Just think of the bouncing
> cows app)

He's getting at the fact that there are much better ways to deal with
this problem. The issue here is that we seem to be expected to swallow
whatever Google throws at us, regardless of the quality of the
solution. It seems like the best argument we have for merging is "we
couldn't think of anything better and we need it yesterday." This might be
a good enough reason for shipping, but it certainly doesn't satisfy the
requirements for merging.

> 
> And if you have two kernels, one with which your device is dead after 1
> hour and one with which your device is dead after 10 hours. Which would
> you prefer? I mean really... this is ridiculous. 

It is absolutely not. If you want to keep power usage down, then
implement real resource management in the scheduler. Suspend blockers
are nothing but a clunky and ineffective means of resource allocation.
As has been pointed out in this thread, there are much better ways of
dealing with this problem.

- Ben
