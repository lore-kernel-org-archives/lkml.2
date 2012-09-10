Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2IJUtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:49:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab2IJUtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:49:21 -0400
Date: Mon, 10 Sep 2012 22:49:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/20] HID: Only dump input if someone is listening
In-Reply-To: <20120910190226.GA877@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1209102248250.22683@pobox.suse.cz>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se> <1346528835-363-17-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1209020927130.20709@pobox.suse.cz> <20120902085211.GA604@polaris.bitmath.org> <alpine.LNX.2.00.1209031515450.20709@pobox.suse.cz>
 <20120906205745.GA419@polaris.bitmath.org> <alpine.LNX.2.00.1209071450190.21679@pobox.suse.cz> <20120910190226.GA877@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Henrik Rydberg wrote:

> > how do you want to handle this? I am fine with all the HID changes. So 
> > either I can take it through my tree and add your Sigoff to the Input 
> > patches (if you are fine with those), or vice versa (or take this through 
> > git branches, i.e. you apply the Input bits, I fetch that branch, and 
> > apply the rest on top of it).
> 
> I went ahead and pushed the (updated) branch to my for-next, to get
> some integration coverage. It is that time. Jiri, I added your
> Acked-by on the hid patches for now, hope that is alright.

Yes, it is, thanks Henrik.

Dmitry, I can pull the whole lot into my tree once you Ack/Signoff the 
input patches, if you wish.

-- 
Jiri Kosina
SUSE Labs
