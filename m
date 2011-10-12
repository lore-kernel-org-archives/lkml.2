Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1JMAuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:50:25 -0400
Received: from ozlabs.org ([203.10.76.45]:55169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1JMAuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:50:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [PATCH] params: make dashes and underscores in parameter names truly equal
In-Reply-To: <1318197817-20964-1-git-send-email-mschmidt@redhat.com>
References: <1318197817-20964-1-git-send-email-mschmidt@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 13 Oct 2011 09:58:07 +1030
Message-ID: <8739exg588.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 00:03:37 +0200, Michal Schmidt <mschmidt@redhat.com> wrote:
> The user may use "foo-bar" for a kernel parameter defined as "foo_bar".
> Make sure it works the other way around too.

Hi Michal,

        Idea is solid, implementation has a few quirks.  As the name
obsolete_checksetup() implies, this was only supposed to be a crutch for
old __setup() calls.  Modern code should be using module_param() or
core_param().

Did you have a specific example?  Perhaps we should work on converting
them all, which would have beneficial side-effects as we poke into old
code...

Thanks!
Rusty.
