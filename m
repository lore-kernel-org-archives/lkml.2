Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab1ESQMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163Ab1ESQMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:12:20 -0400
Date: Thu, 19 May 2011 18:10:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 01/10] signal: remove three noop tracehooks
Message-ID: <20110519161017.GA17265@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-2-git-send-email-tj@kernel.org> <20110518184559.GB1064@redhat.com> <20110519121104.GG627@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519121104.GG627@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/19, Tejun Heo wrote:
>
> On Wed, May 18, 2011 at 08:45:59PM +0200, Oleg Nesterov wrote:
> > On 05/16, Tejun Heo wrote:
> > Heh. What can I say? Yes, this is true. Of course this breaks the out-of-tree
> > project, completely, and you even know its name ;) Although tracehook_get_signal()
> > logic was already broken by other changes...
>
> Yeap, but with ptrace updates, tracehook behaviors, which can't even
> be fully determined without consulting out-of-tree code, are bound to
> change.  Now that ptrace is receiving more capabilities, I don't see
> much point in maintaining them.

I didn't try to argue against this change. Although it will certainly
complicate my life ;)

Btw, this patch conflicts with 25985edcedea6396277003854657b5f3cb31a628
"Fix common misspellings", trivial.

Oleg.

