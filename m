Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1C3GXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 02:23:03 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:48694 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1C3GXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 02:23:01 -0400
Date: Wed, 30 Mar 2011 08:22:59 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH]arch:Kconfig.locks Remove unused config option.
Message-ID: <20110330062258.GA2600@osiris.boeblingen.de.ibm.com>
References: <1301416611-3651-1-git-send-email-justinmattock@gmail.com>
 <20110329175302.GF8529@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329175302.GF8529@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 01:53:02PM -0400, Steven Rostedt wrote:
> On Tue, Mar 29, 2011 at 09:36:51AM -0700, Justin P. Mattock wrote:
> > using a cleanup script I found this, could be real/fake not sure
> > I grepped the whole kernel and only found this. If/when you have
> > time let me know..
> 
> This was added by: 36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
> mutex: have non-spinning mutexes on s390 by default
> 
> and removed by: fa188ae1657d6edc7963d524ce9a0650fe725242
> [S390] mutex: enable spinning mutex on s390
> 
> So I think you are safe in removing it.

Yes, that's just a leftover.

> 
> > 
> > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
