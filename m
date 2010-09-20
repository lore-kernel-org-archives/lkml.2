Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0ITPLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:11:15 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:51163 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab0ITPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:11:13 -0400
Subject: Re: Software error at bugzilla.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
To: Berthold Cogel <cogel@uni-koeln.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C967131.8030802@uni-koeln.de>
References: <4C967131.8030802@uni-koeln.de>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 20 Sep 2010 11:10:16 -0400
Message-ID: <1284995416.25649.0.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 22:23 +0200, Berthold Cogel wrote:

> I'm getting an error at https://bugzilla.kernel.org.
> 
> Software error:
> 
> The ./data/params file does not exist. You probably need to run 
> checksetup.pl. at Bugzilla/Config.pm line 333.
> Compilation failed in require at /var/www/bugzilla/show_bug.cgi line 27.
> BEGIN failed--compilation aborted at /var/www/bugzilla/show_bug.cgi line 27.

I reported it, and it was promptly fixed (thanks to warthog9!).

Jon.


