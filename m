Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0JLPhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:37:43 -0400
Received: from kroah.org ([198.145.64.141]:48656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0JLPhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:37:43 -0400
Date: Tue, 12 Oct 2010 08:28:18 -0700
From: Greg KH <greg@kroah.com>
To: Alasdair G Kergon <agk@redhat.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [stable] dm-crypt: plain64 IV support for -stable?
Message-ID: <20101012152818.GB13584@kroah.com>
References: <20101012132511.GA24455@khazad-dum.debian.net> <20101012133226.GB30719@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012133226.GB30719@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 02:32:26PM +0100, Alasdair G Kergon wrote:
> On Tue, Oct 12, 2010 at 10:25:11AM -0300, Henrique de Moraes Holschuh wrote:
> > Would it be possible to add commit 61afef614b013ee1b767cdd10325acae1db1f4d2
> > "dm crypt: add plain64 iv" to -stable?
>  
> I've no objections - it's a simple and safe patch - but technically it's
> an enhancement: it's up to the stable maintainers to decide.

Yeah, I don't think it falls under the -stable rules, so sorry, I will
not take it.

thanks,

greg k-h
