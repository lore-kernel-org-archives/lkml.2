Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab1ANBDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:03:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343Ab1ANBDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:03:43 -0500
MIME-Version: 1.0
In-Reply-To: <20110113161115.1d564448@nehalam>
References: <4D2F03F2.4000707@fusionio.com> <AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
 <4D2F51B5.6060105@fusionio.com> <AANLkTi=PDEyJNN3aKhHWzCKrTfzib-VCdvgD7auoWuzD@mail.gmail.com>
 <20110113141957.1eaf4940@nehalam> <AANLkTikdULkbB83Us_zXivv8Y5FGdHrixUXRiitacaSh@mail.gmail.com>
 <20110113161115.1d564448@nehalam>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 17:03:21 -0800
Message-ID: <AANLkTimZWMJQfc6E-ke+SbpaTeG9UKA--g=qFQa+11aW@mail.gmail.com>
Subject: Re: [GIT PULL] block driver updates for 2.6.38
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 4:11 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
>
> It appears to be a different problem (not HPET MSI). Not sure what
> is causing it, but even 2.6.35 can't format a floppy without error.

Do you actually know that the hardware is good (ie does _any_ version
of Linux work)?

Floppy disks and drives have not been known for their robustness, and
most of them tend to be pretty old by now.

Dang, I think I should just try to go to Fry's and see if I can find a
floppy drive somewhere. Not that I even know if my motherboards
necessarily even have the _pins_ to connect it any more.

                         Linus
