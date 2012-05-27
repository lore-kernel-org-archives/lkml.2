Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2E0Ilb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 04:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2E0Il2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 04:41:28 -0400
Date: Sun, 27 May 2012 11:41:26 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com,
        Dave Jones <davej@redhat.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kvm: KVM internal error. Suberror: 1
Message-ID: <20120527084126.GM9769@redhat.com>
References: <1336324765.3638.4.camel@lappy>
 <4FA787D5.6040508@redhat.com>
 <CA+1xoqf7W1WsEvMHCEUZjBHJVUCaefnGo9qxu0pttCtoUURseg@mail.gmail.com>
 <CA+1xoqeha3EcYCy=sjER-9B0wn8wTdT-cUTwnvs7uN38uYFpmQ@mail.gmail.com>
 <20120527062129.GK9769@redhat.com>
 <CA+1xoqeT0rSymQDT=k9YhUNnbvVwnkY0SKYbMFHWft40uLfndg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqeT0rSymQDT=k9YhUNnbvVwnkY0SKYbMFHWft40uLfndg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 10:23:23AM +0200, Sasha Levin wrote:
> On Sun, May 27, 2012 at 8:21 AM, Gleb Natapov <gleb@redhat.com> wrote:
> > On Sun, May 27, 2012 at 02:55:39AM +0200, Sasha Levin wrote:
> >> On Fri, May 11, 2012 at 1:40 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> >> > I wasn't able to reproduce this issue so far.
> >>
> >> So I've managed to hit this again, this time with a 3.4 host kernel:
> >>
> > Do you have this instance of QEMU running?
> 
> Nope, qemu pretty much hangs at that point, so I've killed it.
> 
Guest hangs, but not qemu.

> Should I wait with that next time?
Yes. You can inspect guest's state further.

--
			Gleb.
