Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2DMSy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:54:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44086 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755979Ab2DMSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:54:57 -0400
X-Sasl-enc: h05weHmMeYBOiyvmSH53bAASgJ6z96DHBdimupR5mNnx 1334343296
Date: Fri, 13 Apr 2012 15:54:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: suspected regression in 3.0.28 - applications having problems
 binding to ports
Message-ID: <20120413185452.GA7172@khazad-dum.debian.net>
References: <20120413181856.GA2286@nik-comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413181856.GA2286@nik-comp.lan>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Nikola Ciprich wrote:
> I'd like to report following suspicious behaviour of 3.0.27 kernel.
> 
> On one of our production boxes, after upgrading from 3.0.26 to 3.0.27,
> applications started to behave weird after ~1 day uptime.
> Squid started reporting problems binding to port, nagios misbehaved, etc.
> I was forced to revert to 3.0.26. We tried to reproduce the problem but were unsuccessful.
> After ~1 week without problems with 3.0.26, I tried upgrading this production box to 3.0.27
> again to see what happens and the problem appeared again after about one day.
> 
> imap started reporting problems:
> EMAIL DELIVERY CRITICAL - imap failed: IMAP RECEIVE CRITICAL - Could not connect to A.B.C.D port 993: IO::Socket::INET6 configuration
> 
> same for squid:
> commBind: Cannot bind socket FD 21 to 0.0.0.0: (98) Address already in use
> 
> nagios processes went totally nuts.
> 
> There was no other change except for the kernel upgrade.
> The box is x86_64 quad CPU 4GB machine, what might be important, we're using
> IPv6 as well.
> I don't see any suspicious (at least to me) patch between 3.0.26 and 3.0.27.
> Since it seems to take quite a long to reproduce, I haven't tried bisect yet, first
> wanted to ask - hasn't anyone experienced similar problems?

Did you test 3.0.28?  Your subject line mentions 3.0.28, which was released
a few hours ago, but the body of the email only mentions a regression in
3.0.27 when compared to 3.0.26...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
