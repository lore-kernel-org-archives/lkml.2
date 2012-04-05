Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2DEKPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:15:13 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:33722 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2DEKPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:15:10 -0400
Message-ID: <1333620908.8191.1.camel@shrek.rexursive.com>
Subject: Re: [PATCH v8]: Hibernation: lower/better control the amount of
 pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Date: Thu, 05 Apr 2012 20:15:08 +1000
In-Reply-To: <1333432393.2035.13.camel@shrek.rexursive.com>
References: <1333418527.2035.11.camel@shrek.rexursive.com>
	 <201204030631.24974.rjw@sisk.pl>
	 <1333432393.2035.13.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 15:53 +1000, Bojan Smojver wrote:
> Hopefully not, but that will depend on what people find out in
> testing.

I just got confirmation that the patch indeed solves the hang problem in
3.2 and page allocation errors in 3.3:

https://bugzilla.redhat.com/show_bug.cgi?id=785384#c68

Could you please queue it up for 3.4 and then stable.

Thanks,
-- 
Bojan

