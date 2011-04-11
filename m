Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1DKPSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:18:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751Ab1DKPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110411080254.403d3166@nehalam>
References: <20110411050155.GA2507@feather> <20110411080254.403d3166@nehalam>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Apr 2011 08:12:40 -0700
Message-ID: <BANLkTinVGTOAsxG1CiJO1mSGRxBSNP5P4Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] uts: Set default hostname to "localhost", rather
 than "(none)"
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Josh Triplett <josh@joshtriplett.org>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 8:02 AM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
>
> It makes sense but this behavior has existed so long in Linux
> that some distro might actually be depending on it.

Yes. Also, quite frankly, I do _not_ think that "localhost" is in any
way a more correct hostname.

I'd rather have an obviously invalid hostname for a machine that
hasn't been set up correctly than one that might work by random
chance.

                                    Linus
