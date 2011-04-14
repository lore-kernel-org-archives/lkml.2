Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1DONGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:06:25 -0400
Received: from ozlabs.org ([203.10.76.45]:41375 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab1DONGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:06:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stratos Psomadakis <psomas@ece.ntua.gr>, linux-kernel@vger.kernel.org
Subject: Re: Two questions about paravirt boot sequence(head_32.S)
In-Reply-To: <4DA6CD8F.6080206@ece.ntua.gr>
References: <4DA6CD8F.6080206@ece.ntua.gr>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 14 Apr 2011 21:40:05 +0930
Message-ID: <8762qhavaa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 13:33:51 +0300, Stratos Psomadakis <psomas@ece.ntua.gr> wrote:
> 2)I think that xen doesn't use any more the hardware subarch boot
> parameter, and uses a 'different' path/boot sequence, hence the
> xen_entry in head_32.S is not needed any more. Am I missing something?

Yep, Xen never actually used it.

Cheers,
Rusty.
