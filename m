Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081Ab0IEGSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:18:03 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35272 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab0IEGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:18:00 -0400
Date: Sun, 5 Sep 2010 08:17:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-kbuild@vger.kernel.org, aris@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: fix oldnoconfig to do the right thing
Message-ID: <20100905061758.GA29547@merkur.ravnborg.org>
References: <20100901152130.GY2684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901152130.GY2684@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 11:21:30AM -0400, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Commit 861b4ea4 broke oldnoconfig when removed the oldnoconfig checks on
>                        if (input_mode == nonint_oldconfig ||
>                            input_mode == oldnoconfig) {
>                                if (input_mode == nonint_oldconfig &&
>                                    sym->name &&
>                                     !sym_is_choice_value(sym)) {
> to avoid oldnoconfig chugging through the else stanza.
> 
> Fix that to restore expected behaviour (which I've confirmed in the
> Fedora kernel build that the configs end up looking the same.)

I played aroud with this.
I looks like the only difference I got was that before
your patch oldnoconfig produced a lot of output to stdout.
With your patch is was silent.

The resulting config was the same.

We obviously want the silent variant.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
