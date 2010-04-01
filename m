Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0DAGI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:08:59 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42095 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198Ab0DAGIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:08:53 -0400
Date: Thu, 1 Apr 2010 08:08:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: dave b <db.pub.mail@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
Message-ID: <20100401060844.GB1329@ucw.cz>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com> <19346.6765.457769.167118@pilspetsen.it.uu.se> <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com> <20100311133353.GC25011@n2100.arm.linux.org.uk> <20100315010238.GJ6491@shareable.org> <25ae2d691003260312h62b7f853s99a2fa483a6a0847@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ae2d691003260312h62b7f853s99a2fa483a6a0847@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-03-26 21:12:34, dave b wrote:
> I believe that the 2.6.32.7 kernel I compiled and was using on the
> device while compiling the 2.6.33 kernel had *issues* (although most
> likely not kernel related). In particular various issues (apt-get not
> working) including on one piece of hardware using the kernel binary as
> produced by others.

Interesting. I remember apt-get failing recently; I thought my
databases went corrupt, but then it started to work magically...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
