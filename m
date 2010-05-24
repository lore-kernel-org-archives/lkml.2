Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0EXPHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:07:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0EXPHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:07:37 -0400
Date: Mon, 24 May 2010 16:07:29 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with
	name_to_dev_t
Message-ID: <20100524150729.GZ3991@agk-dp.fab.redhat.com>
Mail-Followup-To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, snitzer@redhat.com
References: <1274294304-30606-1-git-send-email-wad@chromium.org> <1274294304-30606-3-git-send-email-wad@chromium.org> <20100524115737.GY3991@agk-dp.fab.redhat.com> <AANLkTik8F43_4SRkH7XpfX5CTQ-xQ_8f3_yJTjDqSulU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik8F43_4SRkH7XpfX5CTQ-xQ_8f3_yJTjDqSulU@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 09:44:07AM -0500, Will Drewry wrote:
> fwiw, the only reason for the copy was because |path| is a
> const in the function but not when passed to name_to_dev_t.
> I wasn't sure what the preferred practice was so I just duped
> the data needed.
 
Well check that it is treated as 'const' and send a separate patch to
the maintainer to add const, perhaps?  If it isn't const (why would
that be?), then yes we'd need to copy it.

Alasdair

