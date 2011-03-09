Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab1CIQ7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:59:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1CIQ7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:59:02 -0500
Date: Wed, 9 Mar 2011 17:50:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [RFC PATCHSET] ptrace,signal: Fix notifications to the real
	parent while ptraced
Message-ID: <20110309165007.GA1435@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Tejun Heo wrote:
>
> This patchset implements "P2. Fix notifications to the real parent" of
> the ptrace job control improvements proposal[1].

And at first glance this does what we discussed before. I mean, even if
(perhaps) this series has some problems/bugs it looks right "in general"
to me.

> As the whole job control / ptrace logic is quite delicate, I tried to
> be very granual with changes and add plenty of explanations for
> subtleties.

Yeah... And right now I have some concerns about the details, but I am
not ready to share them. Will try tomorrow, it turns out I need to re-read
the previous series.

Say, even 1/8 doesn't look exactly right with the current ptrace code,
WARN_ON_ONCE() can be easily triggered afaics.

Oleg.

