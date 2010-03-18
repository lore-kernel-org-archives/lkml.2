Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0CRWDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:03:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36251 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668Ab0CRWDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:03:54 -0400
Date: Thu, 18 Mar 2010 22:06:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: drepper@gmail.com, Anthony Liguori <anthony@codemonkey.ws>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318220654.4305b9e0@lxorguk.ukuu.org.uk>
In-Reply-To: <20100318205655.GB4821@elte.hu>
References: <20100318201826.GA20588@elte.hu>
	<g6y0y1gaeew5bcwbUYAxe124vaj_firegpg@mail.gmail.com>
	<20100318205655.GB4821@elte.hu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So it's good enough to be in Fedora/RHEL but not good enough to be in upstream 
> glibc? How is that possible? Isnt that a double standard?

Yes its a double standard

Glibc has a higher standard than Fedora/RHEL.

Just like the Ubuntu kernel ships various ugly unfit for upstream kernel
drivers.

> kernel's fault. But glibc is certainly not being helpful in that situation 
> either and your earlier claim that you are only waiting for the patches is 
> rather dishonest.

I am sure Ulrich is being totally honest, but send him the patches and
you'll find out. Plus you will learn what the API should look like when
you try and create them ...

Alan
