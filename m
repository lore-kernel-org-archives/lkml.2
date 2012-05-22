Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab2EVCgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932811Ab2EVCgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:36:10 -0400
Date: Mon, 21 May 2012 22:36:05 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.4+ dcache BUG.
Message-ID: <20120522023604.GA10591@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120522011152.GA18115@redhat.com>
 <20120522013949.GA31883@redhat.com>
 <CA+55aFzYd9b4CF30vK+rT_daKLXKBd7kOpsOZtoPKcDnsgYAxA@mail.gmail.com>
 <CA+55aFwd9DGhUeMGqRxYm2qgENPCjChTDFK6G-mkNMp+WUKtdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwd9DGhUeMGqRxYm2qgENPCjChTDFK6G-mkNMp+WUKtdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 07:14:32PM -0700, Linus Torvalds wrote:
 > On Mon, May 21, 2012 at 6:58 PM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > I'm going to assume it's the exact same thing (and thus hopefully
 > > fixed by the revert that I just pushed out)
 > 
 > Oops. Except I hadn't actually pushed after committing.
 > 
 > NOW it's pushed out.

Yeah, that looks much better. 

 > And please do a "git fetch --tags" too to make sure you have the tags,
 > and your "git describe" gives better output than
 > v3.3-rc7-<some-huge-number> ;)

Done, thanks.

	Dave

