Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2EEIaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:30:06 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:52970 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2EEIaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:30:01 -0400
Date: Sat, 5 May 2012 10:30:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: linux arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC] move link of vmlinux to a script
Message-ID: <20120505083000.GB14006@merkur.ravnborg.org>
References: <20120422212220.GA6537@merkur.ravnborg.org> <21193.1335776659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21193.1335776659@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 10:04:19AM +0100, David Howells wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > +#   C = Comon symbol
> 
> Should be "Common" I presume.  Could you fix it whilst you're at it?

I ended up not touching this file.

	Sam
