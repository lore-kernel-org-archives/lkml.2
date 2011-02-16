Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1BPWaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:30:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186Ab1BPWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:30:15 -0500
MIME-Version: 1.0
In-Reply-To: <20110216171938.78fd4a2f@katamari>
References: <20110216171938.78fd4a2f@katamari>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 14:29:25 -0800
Message-ID: <AANLkTik_kqob1-BzY+kguUz-NePYeyQeK-3Od3kyQJpi@mail.gmail.com>
Subject: Re: [Patch] Revert block_dev read-only check
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 2:19 PM, Chuck Ebbert <cebbert@redhat.com> wrote:
> This reverts commit 75f1dc0d076d1c1168f2115f1941ea627d38bd5a. The revert
> could not be done automatically because changes after that commit
> altered the code too much.

I really want to hear about _why_ something is reverted too. I'm not
taking patches without explanations. And explaining that it's
non-automatic (and why _that_ is), is not explaining why it needed to
be reverted in the first place.

Please. Think of the poor people who wonder why..

                 Linus
