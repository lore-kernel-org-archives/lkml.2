Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0D0TJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab0D0TJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:09:35 -0400
Date: Tue, 27 Apr 2010 16:09:31 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/6] Enable pvclock flags in vcpu_time_info structure
Message-ID: <20100427190931.GT16166@mothafucka.localdomain>
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
 <1272303988-21929-2-git-send-email-glommer@redhat.com>
 <4BD727D6.20609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD727D6.20609@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 09:07:18PM +0300, Avi Kivity wrote:
> On 04/26/2010 08:46 PM, Glauber Costa wrote:
> >This patch removes one padding byte and transform it into a flags
> >field. New versions of guests using pvclock will query these flags
> >upon each read.
> >
> >Flags, however, will only be interpreted when the guest decides to.
> >It uses the pvclock_valid_flags function to signal that a specific
> >set of flags should be taken into consideration. Which flags are valid
> >are usually devised via HV negotiation.
> >
> >
> >+void pvclock_valid_flags(u8 flags);
> 
> set_pvclock_valid_flags() (or just set_pvclock_flags?
> pvclock_set_flags()?).  The original name looks like a getter.
Ok, will change it.
