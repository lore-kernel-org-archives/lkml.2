Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1KASBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:01:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1KASBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:01:49 -0400
Date: Tue, 1 Nov 2011 11:00:39 -0700
From: Greg KH <gregkh@suse.de>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: Remove unsafe device module references
Message-ID: <20111101180038.GB4241@suse.de>
References: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
 <20111101170156.GA8925@suse.de>
 <CANq1E4S07S2kNTmAxQRa4mEVKrGnS7cTHKqPoHEzLOyu3Mfqzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4S07S2kNTmAxQRa4mEVKrGnS7cTHKqPoHEzLOyu3Mfqzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 06:52:11PM +0100, David Herrmann wrote:
> My solution: Some parent subsystem of us must take and release this
> module-refcnt instead of us, so this bug doesn't occur.

Yes, that is the ultimate solution for something like this.

But, in reality, we don't care about module unloading races as there are
plenty of other issues involved there where things can go bad, so we
just try the best we can :)

thanks,

greg k-h
