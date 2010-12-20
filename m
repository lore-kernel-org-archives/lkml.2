Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0LTKgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:36:01 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42309 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0LTKf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:35:59 -0500
Subject: Re: [Bug #20232] kworker consumes ~100% CPU on HP Elitebook 8540w
 running 2.6.36_rc6-git4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ozan Caglayan <ozan@pardus.org.tr>, 2010-04-22@ogre.sisk.pl,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <xqq2Z3iR9HJ.A.lMH.Q2fDNB@chimera>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
	 <xqq2Z3iR9HJ.A.lMH.Q2fDNB@chimera>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 11:35:13 +0100
Message-ID: <1292841313.2708.137.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 13:50 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20232
> Subject		: kworker consumes ~100% CPU on HP Elitebook 8540w running 2.6.36_rc6-git4
> Submitter	: Ozan Caglayan <ozan@pardus.org.tr>
> Date		: 2010-10-13 06:13 (68 days old)

I'd be thinking that kworker going wonky is something for Tejun to have
a look at.. Anyway, is it still relevant for current kernels?
