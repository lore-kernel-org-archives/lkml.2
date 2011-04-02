Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1DBPLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 11:11:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36717 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1DBPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 11:11:39 -0400
Date: Sat, 2 Apr 2011 17:11:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Florian Mickler <florian@mickler.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        kurup_avinash@yahoo.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        sedat.dilek@gmail.com, akpm@linux-foundation.org, zersaa@gmail.com,
        stable@kernel.org, maciej.rutecki@gmail.com
Subject: Re: [stable] [PATCH][POKE] Skip looking for ioapic overrides when ioapics are not present
Message-ID: <20110402151134.GB20069@one.firstfloor.org>
References: <1301558489-4198-1-git-send-email-florian@mickler.org> <20110331084342.GA30105@elte.hu> <20110331125941.661a0af9@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331125941.661a0af9@schatten.dmk.lab>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thank you. Will do if it turns out this is still necessary. 
> Paul Bolle mentioned in another messgage that there is a commit in
> 2.6.38 to the same effect:
> 
> commit 678301ecadec24ff77ab310eebf8a32ccddb1850 
> ("x86, ioapic: Don't warn about non-existing IOAPICs if we have none")

Folks, do you want that commit in .35 longterm or should some other
patch be used?  

Thanks,
-Andi
