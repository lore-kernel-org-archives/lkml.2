Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab2EIHl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:41:56 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:48711 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2EIHlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:41:55 -0400
Message-ID: <1336549313.2097.28.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both: draft
From: Bojan Smojver <bojan@rexursive.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 17:41:53 +1000
In-Reply-To: <20120509072418.GC19853@liondog.tnic>
References: <1336379825.2097.5.camel@shrek.rexursive.com>
	 <201205072214.13912.rjw@sisk.pl>
	 <1336446956.2097.16.camel@shrek.rexursive.com>
	 <201205082326.42970.rjw@sisk.pl> <20120509072418.GC19853@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 09:24 +0200, Borislav Petkov wrote:
> Oh goody, that's what the apples do - suspend to ram and disk. When
> you have the patch ready, you'll have another tester, just send it on
> my way too pls :-).

Pretty much the same thing submitted to Rafael here:

http://marc.info/?l=linux-kernel&m=133651588229850&w=2

It worked on my ThinkPad, but YMMV. :-)

-- 
Bojan

