Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab1GYHzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:55:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41720 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1GYHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:55:37 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
In-Reply-To: <4E2D1D07.9020009@redhat.com>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	 <4E2CC489.1090509@codemonkey.ws>
	 <CAOJsxLH-poY4-wEUPqAa8bzK+1WJ0UYtSuue72RYwcd_D0kx_A@mail.gmail.com>
	 <4E2D1D07.9020009@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 25 Jul 2011 10:55:03 +0300
Message-ID: <1311580503.3446.32.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 10:36 +0300, Avi Kivity wrote:
> On 07/25/2011 10:27 AM, Pekka Enberg wrote:
> > Hi Anthony,
> >
> > On Mon, Jul 25, 2011 at 4:19 AM, Anthony Liguori<anthony@codemonkey.ws>  wrote:
> > >  lguest already does this and lives in the kernel.
> >
> > Does Lguest have SMP, usermode networking, and GUI support?
> >
> 
> IIRC, yes, no, and no.

Theres no SMP support in lguest.

-- 

Sasha.

