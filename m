Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab0JZRh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:37:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab0JZRh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:37:57 -0400
Date: Tue, 26 Oct 2010 13:37:56 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Luke Hutchison <luke.hutch@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel bug?: Reopening a browser session with many tabs seems to
 shut down networking stack
Message-ID: <20101026173756.GU8332@bombadil.infradead.org>
References: <AANLkTinZQJPwZdg9GT1VLm-+cyXK8DoL8W9quRszwJZF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTinZQJPwZdg9GT1VLm-+cyXK8DoL8W9quRszwJZF@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 01:13:35AM -0400, Luke Hutchison wrote:
> My computer has been close to unusable for moderate browsing activity
> for about 8 months of the year so far, across nearly two releases of
> Fedora (F13 and F14 beta).  I filed the above bug report but it was
> never commented on by RedHat engineers.  I figured the bug was
> probably visible enough that somebody else should notice it and I just
> kept hoping the next update would contain a fix, but not yet.
> 

If you want to get the attention of the Fedora kernel team, the mailing
list is probably the best place. We're outnumbered by several million to
one so staying on top of the bugpile is an almost impossible situation
unless your bug is making things explode.

> I don't know if this is a Fedora-specific bug but figured I should
> report it upstream too.  Please advise me as to how to debug this
> problem further.  (I haven't seen anything that looks suspicious in
> dmesg output or /var/log/messages, to start with.)
> 

It's fairly unlikely, as we don't typically patch the network stack at
all.

If you can't reproduce it with the upstream kernel that would be
interesting.

regards, Kyle
