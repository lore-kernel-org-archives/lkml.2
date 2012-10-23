Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab2JWNok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:44:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46488 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933117Ab2JWNoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:44:38 -0400
Date: Tue, 23 Oct 2012 14:44:35 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3 v2] firmware: Convert firmware path setup from an
	array to a list
Message-ID: <20121023134435.GA16409@opensource.wolfsonmicro.com>
References: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com> <1350996776-17864-2-git-send-email-dp@opensource.wolfsonmicro.com> <CACVXFVOMb3A=9wKm+-wnsg7=dTbjJjU2gZrUPBDK=TROTx_erA@mail.gmail.com> <20121023132939.GA10160@opensource.wolfsonmicro.com> <CACVXFVPsqWCaqGpfWGXsGP=bUwz-GnpLLDC+j4tCMBGECZ=8DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPsqWCaqGpfWGXsGP=bUwz-GnpLLDC+j4tCMBGECZ=8DQ@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 09:37:24PM +0800, Ming Lei wrote:
> On Tue, Oct 23, 2012 at 9:29 PM, Dimitris Papastamos
> <dp@opensource.wolfsonmicro.com> wrote:
> 
> >
> > Hi sorry for being unclear, I mentioned in the old thread that
> > I've not had time to fix this properly (or think about a proper
> > fix), Greg requested a rebase on top of linux-next, however, at
> > least for firmware path listing.
> >
> > Should I amend the commit description so it is not misleading and
> > remove the 'updating' part?
> 
> In fact, I also questioned on path listing too in last thread too.

I don't currently have a use-case for this, so not sure how useful
it is to list the default fw paths.

Thanks,
Dimitris
