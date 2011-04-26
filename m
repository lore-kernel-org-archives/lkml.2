Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab1DZUBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:01:42 -0400
Received: from 1wt.eu ([62.212.114.60]:35063 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab1DZUBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:01:41 -0400
Date: Tue, 26 Apr 2011 22:00:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Julien Tinnes <jln@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 104/173] Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code
Message-ID: <20110426200056.GD19594@1wt.eu>
References: <46075c3a3ef08be6d70339617d6afc98@local> <20110425200237.513372128@pcw.home.local> <20110426130349.GA7103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426130349.GA7103@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Tue, Apr 26, 2011 at 03:03:50PM +0200, Oleg Nesterov wrote:
> On 04/25, Willy Tarreau wrote:
> >
> > 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Julien Tinnes <jln@google.com>
> >
> > commit da48524eb20662618854bb3df2db01fc65f3070c upstream.
> 
> This also needs 243b422af9ea9af4ead07a8ad54c90d4f9b6081a

Thanks for checking. In fact we already have it in patch 121 so we're fine.

Best regards,
Willy

