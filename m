Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0CVNBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:01:37 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:42053 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0CVNBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cnIyFfynCG4vGsuRZQoVA61fGeV+oGdyVD3bwp5ZNXLkjlw1xDk8zV4j2z/A/dMUEp
         xAhegQsati6oOB+aaKrunmlmlQrs5XVYcGqZTRJb/S6GY1lnvaJJ0+Vhh8EZ8caRSkxx
         IlWVZnANIaIPUteVKFEFF6+0YFBX2n2amzkH8=
MIME-Version: 1.0
In-Reply-To: <4BA76746.1000505@redhat.com>
References: <20100318172805.GB26067@elte.hu> <4BA3747F.60401@codemonkey.ws>
	 <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com>
	 <20100321203121.GA30194@elte.hu> <4BA6900B.1040408@redhat.com>
	 <20100321215207.GA13219@elte.hu> <4BA712F0.5030806@redhat.com>
	 <20100322112340.GD3483@elte.hu> <4BA76746.1000505@redhat.com>
Date: Mon, 22 Mar 2010 15:01:32 +0200
X-Google-Sender-Auth: 6a1a290b8279ef3d
Message-ID: <84144f021003220601q1b4b9050x5eb87dfaf10c3c85@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>, sandmann@daimi.au.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Mon, Mar 22, 2010 at 2:49 PM, Avi Kivity <avi@redhat.com> wrote:
> Seems like perf is also split, with sysprof being developed outside the
> kernel.  Will you bring sysprof into the kernel?  Will every feature be
> duplicated in prof and sysprof?

I am glad you brought it up! Sysprof was historically outside of the
kernel (with it's own kernel module, actually). While the GUI was
nice, it was much harder to set up compared to oprofile so it wasn't
all that popular. Things improved slightly when Ingo merged the custom
kernel module but the _userspace_ part of sysprof was lagging behind a
bit. I don't know what's the situation now that they've switched over
to perf syscalls but you probably get my point.

It would be nice if the two projects merged but I honestly don't see
any fundamental problem with two (or more) co-existing projects.
Friendly competition will ultimately benefit the users (think KDE and
Gnome here).

                        Pekka
