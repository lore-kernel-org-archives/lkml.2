Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab1GGAiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:38:00 -0400
Received: from ozlabs.org ([203.10.76.45]:47911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab1GGAiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:38:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] virtio: expose for non-virtualization users too
In-Reply-To: <4E1391C2.2090904@zytor.com>
References: <1309874774-31689-1-git-send-email-ohad@wizery.com> <4E1391C2.2090904@zytor.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 06 Jul 2011 14:55:43 +0930
Message-ID: <87aacs0ylk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jul 2011 15:35:46 -0700, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 07/05/2011 07:06 AM, Ohad Ben-Cohen wrote:
> > virtio has been so far used only in the context of virtualization,
> > and the virtio Kconfig was sourced directly by the relevant arch
> > Kconfigs when VIRTUALIZATION was selected.
> > 
> > Now that we start using virtio for inter-processor communications,
> > we need to source the virtio Kconfig outside of the virtualization
> > scope too.
> > 
> 
> Seems reasonable to me.

Me too.  When you're happy, please send.

Thanks,
Rusty.
