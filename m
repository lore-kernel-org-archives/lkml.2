Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2DXOff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:35:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16219 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2DXOfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:35:34 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 95.21.35.138
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19nk1ybg0m5FdBv1qq/ID1z
Date: Tue, 24 Apr 2012 16:35:29 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: linux-kernel@vger.kernel.org
Subject: perf fails to build on 3.2.16 and 3.3.3
Message-ID: <20120424143529.GP1927@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looked a bit at the archives, and I have not seen this reported.

I imagine it won't be overseen for long, but at least it got into the stable
releases.

Does anybody know a patch that fixes the build?

...
    CC util/hist.o
util/hist.c: In function '__hists__add_entry':
util/hist.c:240:27: error: invalid type argument of '->' (have 'struct hist_entry')
util/hist.c:241:23: error: invalid type argument of '->' (have 'struct hist_entry')
make: *** [util/hist.o] Error 1


Regards,
Lluís.
