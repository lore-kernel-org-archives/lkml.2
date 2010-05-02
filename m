Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab0EBUGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 16:06:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39741 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756030Ab0EBUGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 16:06:23 -0400
Date: Sun, 2 May 2010 22:06:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hugh.dickins@tiscali.co.uk, ngupta@vflare.org,
       JBeulich@novell.com, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
Message-ID: <20100502200615.GA9051@elf.ucw.cz>
References: <1c02a94a-a6aa-4cbb-a2e6-9d4647760e91@default4BD43033.7090706@redhat.com>
 <ce808441-fae6-4a33-8335-f7702740097a@default>
 <20100428055538.GA1730@ucw.cz>
 <1272591924.23895.807.camel@nimitz>
 <4BDA8324.7090409@redhat.com>
 <084f72bf-21fd-4721-8844-9d10cccef316@default>
 <4BDB026E.1030605@redhat.com>
 <4BDB18CE.2090608@goop.org4BDB2069.4000507@redhat.com>
 <3a62a058-7976-48d7-acd2-8c6a8312f10f@default20100502071059.GF1790@ucw.cz>
 <47d6b5d9-beb5-4e49-9910-064d6f7b13e5@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47d6b5d9-beb5-4e49-9910-064d6f7b13e5@default>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > So what needs to be said here is 'frontswap is XX times faster than
> > swap_ops based solution on workload YY'.
> 
> Are you asking me to demonstrate that swap-to-hypervisor-RAM is
> faster than swap-to-disk?

I would like comparison of swap-to-frontswap vs. swap-to-RAMdisk.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
