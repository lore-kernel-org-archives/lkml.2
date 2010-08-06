Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728Ab0HFT3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:29:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965691Ab0HFT3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <20100805220511.GA7040@comet.dominikbrodowski.net>
References: <20100805220511.GA7040@comet.dominikbrodowski.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 12:28:31 -0700
Message-ID: <AANLkTin1x7P-4p2grwd=0fYoCB53uDkxgOETzXqk12X1@mail.gmail.com>
Subject: Re: [git pull] PCMCIA updates for 2.6.36
To: torvalds@osdl.org, akpm@osdl.org, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Cc: akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 3:05 PM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>
> Please pull from that location. The diffstat and list of changes is below,
> the individual diffs are sent (at least) to the linux-pcmcia list.

Hmm. You hadn't done proper removal of dev_info_t from the staging
drivers. I tried to fix it up by hand, but quite frankly, I may well
have messed something up. Please do check the result.

                Linus
