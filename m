Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118Ab0EEJFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:05:06 -0400
Received: from smtp.nokia.com ([192.100.122.233]:40125 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab0EEJFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:05:03 -0400
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Takashi Iwai <tiwai@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
In-Reply-To: <1273049369.3702.127.camel@localhost>
References: <200910290902.13724.rusty@rustcorp.com.au>
	 <201005041154.24658.rusty@rustcorp.com.au>
	 <1272996439.2458.0.camel@localhost.localdomain>
	 <201005051503.42289.rusty@rustcorp.com.au>
	 <1273044314.3702.98.camel@localhost>  <s5hmxwevlm4.wl%tiwai@suse.de>
	 <1273049369.3702.127.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 12:04:18 +0300
Message-ID: <1273050258.3702.133.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 09:04:43.0179 (UTC) FILETIME=[005857B0:01CAEC32]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 11:49 +0300, Artem Bityutskiy wrote:
> > Fixing in the way of the later upstream is a bit too intrusive as a
> > stable patch.  So, I'm also not sure whether we should take it,
> > too...
> 
> To be frank I do not really understand what you mean.

If you meant 'let's not change it 2.6.34' - fair enough, it was already
in 2.6.32, so there is probably no reason to hurry. But I suggest to
still consider this as a big issue and fix as soon as we can.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

