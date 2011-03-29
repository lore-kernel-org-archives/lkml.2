Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1C2PVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:21:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1C2PVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HPot23+dgyLcbHA9T4EG/kX3pp0Vxz92+ptR2Rtlh1yptQpkWImk/8a0hGP1X+FNSA
         aKrKzu+tuOSpJC2VaJW51UNs3GR57Lk2EVx+VdGqHABTJfkhX2cbE4VRoa3lbF2wieN/
         AUS4pIT0R6Ooc85/zQRympqXKMD4xapNSCMh0=
MIME-Version: 1.0
In-Reply-To: <849307$c7c8q8@azsmga001.ch.intel.com>
References: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk>
	<AANLkTin0bicOYyY2WCaBxN276t5RV-Q9UZVr=WQ6NmQe@mail.gmail.com>
	<1bdc18$k1kc9s@fmsmga002.fm.intel.com>
	<AANLkTi=Adq8i_qoiHhLB9K-CkUbT8uHZeg-H8Z3_Kgrw@mail.gmail.com>
	<AANLkTi=ejDZYxyHYWXZiLXG+L1o8BqvQp8CQVhsUf570@mail.gmail.com>
	<849307$c7c8q8@azsmga001.ch.intel.com>
Date: Tue, 29 Mar 2011 18:21:50 +0300
X-Google-Sender-Auth: 3I-TCE4vfFjAMrEhV-59XyldvGU
Message-ID: <AANLkTikwbVBfqBd+ARo2Y3Hm4MYn=VtQy8gn1Rpc17rr@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Move the irq wait queue initialisation into the
 ring init
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 5:32 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 29 Mar 2011 17:22:13 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> No ssh - the box seems to be dead.
>
> But now you have a machine with which to listen out for the netconsole
> scream of anguish...

OK, this gets interesting. With

  netconsole=... loglevel=7

I am not able to reproduce the bug. With

  netconsole=... loglevel=6

I am able to reproduce but nothing is printed to netconsole. I guess
the kernel dies before it's able to set it up.

                        Pekka
