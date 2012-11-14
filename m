Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885Ab2KNNVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:21:55 -0500
Received: from 79.132.231.86.static.edpnet.net ([79.132.231.86]:40545 "EHLO
	mail.offline.be" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1422805Ab2KNNVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:21:54 -0500
Date: Wed, 14 Nov 2012 14:21:47 +0100
From: Marc Duponcheel <marc@offline.be>
To: David Rientjes <rientjes@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Marc Duponcheel <marc@offline.be>
Subject: Re: [3.6 regression?] THP + migration/compaction livelock (I think)
Message-ID: <20121114132146.GA13122@offline.be>
Reply-To: Marc Duponcheel <marc@offline.be>
References: <CALCETrVgbx-8Ex1Q6YgEYv-Oxjoa1oprpsQE-Ww6iuwf7jFeGg@mail.gmail.com>
 <alpine.DEB.2.00.1211131507370.17623@chino.kir.corp.google.com>
 <CALCETrU=7+pk_rMKKuzgW1gafWfv6v7eQtVw3p8JryaTkyVQYQ@mail.gmail.com>
 <alpine.DEB.2.00.1211131530020.17623@chino.kir.corp.google.com>
 <CALCETrXSzNEdNEZaQqB93rpP9zXcBD4KRX_bjTAnzU6JEXcApg@mail.gmail.com>
 <alpine.DEB.2.00.1211131553170.17623@chino.kir.corp.google.com>
 <20121114012234.GB8152@offline.be>
 <alpine.DEB.2.00.1211131750200.408@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211131750200.408@chino.kir.corp.google.com>
Organization: OFFLINE
X-uname: Linux 3.6.6-gentoo x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012 Nov 13, David Rientjes wrote:
> On Wed, 14 Nov 2012, Marc Duponcheel wrote:
> 
> >  Hi all, please let me know if there is are patches you want me to try.
> > 
> >  FWIW time did not stand still and I run 3.6.6 now.
> 
> Hmm, interesting since there are no core VM changes between 3.6.2, the 
> kernel you ran into problems with, and 3.6.6.

 Hi David

 I have not tried yet to repro #49361 on 3.6.6, but, as you say, if
there are no core VM changes, I am confident I can do so just by doing

# echo always > /sys/kernel/mm/transparent_hugepage/enabled

 I am at your disposal to test further, and, if there are patches, to
try them out.

 Note that I only once experienced a crash for which I could not find
relevant info in logs. But the hanging processes issue could always be
reproduced consistently.

 have a nice day

--
 Marc Duponcheel
 Velodroomstraat 74 - 2600 Berchem - Belgium
 +32 (0)478 68.10.91 - marc@offline.be
