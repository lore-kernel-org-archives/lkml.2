Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182Ab0HLPXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:23:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:56967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab0HLPXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:23:38 -0400
Date: Thu, 12 Aug 2010 08:12:26 -0700
From: Greg KH <gregkh@suse.de>
To: John Kacur <jkacur@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE][UNOFFICIAL] 2.6.33.8
Message-ID: <20100812151226.GA21753@suse.de>
References: <AANLkTikK5m_DE_bzcuiqOpoSVqFzUp=GeD5k01foop=E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikK5m_DE_bzcuiqOpoSVqFzUp=GeD5k01foop=E@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 04:58:13PM +0200, John Kacur wrote:
> There are no longer any official 2.6.33 stable releases after 2.6.33.7
> However, 2.6.33.y is the basis for the real-time kernel.

Why is the -rt kernel sticking with this older version?  Any specific
reason to not move to .34 or at the least, .35?

thanks,

greg k-h
