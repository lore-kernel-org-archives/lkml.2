Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab0CSXnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:43:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44990 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0CSXnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:43:31 -0400
X-IronPort-AV: E=Sophos;i="4.51,277,1267419600"; 
   d="scan'208";a="88856401"
Subject: Re: [PATCH -v3] x86: do not free zero sized per cpu areas
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1269041758.28761.33.camel@localhost.localdomain>
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org>
	 <4BA3F8ED.2090600@zytor.com>  <4BA407B8.7070503@kernel.org>
	 <1269041758.28761.33.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 19 Mar 2010 23:43:27 +0000
Message-ID: <1269042207.28761.36.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-19 at 23:35 +0000, Ian Campbell wrote: 
> if (WARN_ONCE(start < end, "blah"))

or rather "start > end"...

Ian.

-- 
Ian Campbell

I am a friend of the working man, and I would rather be his friend
than be one.
		-- Clarence Darrow

