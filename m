Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1AHVZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 16:25:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab1AHVZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 16:25:19 -0500
Date: Sat, 8 Jan 2011 22:25:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 0/5] hid-multitouch: a first step towards multitouch
 unification 
In-Reply-To: <alpine.LNX.2.00.1101072359450.26685@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1101082224130.26685@pobox.suse.cz>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr> <alpine.LNX.2.00.1101072355200.26685@pobox.suse.cz> <alpine.LNX.2.00.1101072359450.26685@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Jan 2011, Jiri Kosina wrote:

> > > all changes are coming from the mails with Henrik:
> > > 
> > > - restricted to new drivers only
> > > - delete mt_buffer struct
> > > - replace/adapt prev_valid in favor of seen_in_this_frame
> > > - integrated fuzz
> > > - introduce MT_QUIRKS
> > > - other small fixes
> > 
> > Hi Bejnamin,
> > 
> > thanks a lot for spinning this up so nicely and quickly.
> > 
> > I have now applied the patchset as-is to the 'multitouch' branch in my 
> > tree.
> 
> Which means -- could you please send any followup patches on top of that 
> branch (i.e. on top of the v3 patchset)? It would help my workflow and 
> make the merging process smoother.

'multitouch' brach now builds, as Linus has taken Dmitry's pull request 
and I have merged from Linus.

So once you have fixed for the minor issues raised by Henrik and once you 
have finished your testing, please send the additional fixes to me and I 
will be merging the branch upstream.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
