Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1DOTgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:36:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1DOTgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:36:19 -0400
Subject: Re: mmotm 2011-04-14 - hangs during boot.
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <8571.1302895705@localhost>
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
	 <9629.1302879429@localhost> <6325.1302893631@localhost>
	 <1302894382.2035.35.camel@laptop>  <8571.1302895705@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Apr 2011 21:35:55 +0200
Message-ID: <1302896155.2388.242.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 15:28 -0400, Valdis.Kletnieks@vt.edu wrote:
> I'll see if I can cherrypick that c2f711 commit out and apply it, or
> have you been churning
> it that much in the last 24 hours? :) 

I'm afraid it doesn't cleanly apply, I stuck it somewhere in the head of
the series and rebased the tail on top to make it all bisectable etc..

