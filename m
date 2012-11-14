Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2KNBvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:51:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53958 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2KNBvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:51:43 -0500
Date: Tue, 13 Nov 2012 17:51:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Marc Duponcheel <marc@offline.be>
cc: Andy Lutomirski <luto@amacapital.net>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [3.6 regression?] THP + migration/compaction livelock (I
 think)
In-Reply-To: <20121114012234.GB8152@offline.be>
Message-ID: <alpine.DEB.2.00.1211131750200.408@chino.kir.corp.google.com>
References: <CALCETrVgbx-8Ex1Q6YgEYv-Oxjoa1oprpsQE-Ww6iuwf7jFeGg@mail.gmail.com> <alpine.DEB.2.00.1211131507370.17623@chino.kir.corp.google.com> <CALCETrU=7+pk_rMKKuzgW1gafWfv6v7eQtVw3p8JryaTkyVQYQ@mail.gmail.com> <alpine.DEB.2.00.1211131530020.17623@chino.kir.corp.google.com>
 <CALCETrXSzNEdNEZaQqB93rpP9zXcBD4KRX_bjTAnzU6JEXcApg@mail.gmail.com> <alpine.DEB.2.00.1211131553170.17623@chino.kir.corp.google.com> <20121114012234.GB8152@offline.be>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Marc Duponcheel wrote:

>  Hi all, please let me know if there is are patches you want me to try.
> 
>  FWIW time did not stand still and I run 3.6.6 now.
> 

Hmm, interesting since there are no core VM changes between 3.6.2, the 
kernel you ran into problems with, and 3.6.6.
