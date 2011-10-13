Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1JMTG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:06:56 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56970 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1JMTGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:06:55 -0400
Date: Thu, 13 Oct 2011 15:06:51 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.de>, Elena Zannoni <elena.zannoni@oracle.com>,
        Dave Jones <davej@redhat.com>, David Zeuthen <davidz@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Ric Wheeler <rwheeler@redhat.com>
Subject: Re: kernel.org keysigning party for the Boston area: October 18,
 2011
Message-ID: <20111013190651.GQ11548@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Jeff Mahoney <jeffm@suse.de>,
	Elena Zannoni <elena.zannoni@oracle.com>,
	Dave Jones <davej@redhat.com>, David Zeuthen <davidz@redhat.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Konrad Rzeszutek Wilk <konrad@darnok.org>,
	Ric Wheeler <rwheeler@redhat.com>
References: <E1RENGE-0007PN-GO@tytso-glaptop.cam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1RENGE-0007PN-GO@tytso-glaptop.cam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:31:54AM -0400, Theodore Ts'o wrote:
> 1.  All attendees send their public keys to a public keyserver. For this
> party, we'll use keyserver.cryptnet.net. If for some reason you don't
                   ^^^^^^^^^^^^^^^^^^^^^^

Sorry, this keyserver no longer exists.  Please use pks.gpg.cz instead.

Actually, you don't need to specify a keyserver as long as you do at
least a day or so in advance, since all of the key servers talk to one
another.  The reason for specifying a specific key servers is for the
lamers who don't bother submitting their key until just before the
deadline, and the key hasn't had a chance to replicate to all of the
other servers yet.

						- Ted
