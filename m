Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab0CaSGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:06:23 -0400
Received: from braint.aber.ac.uk ([144.124.16.42]:42566 "EHLO
	braint.aber.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab0CaSGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:06:21 -0400
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 14:06:21 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=outgoing; d=aber.ac.uk;
	h=Received:Received:Received:Message-ID:Date:Subject:From:To:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance:X-UWA-Mid:X-UWA-Originating-IP:X-UWA-Sophos-Scanned;
	b=EAmXYu9/CZIxPZDdNZqR5o+xRmonYOmw0AeFWtiFkKsftcO2Pdcv7jbkoUk+qnbfEgvU3g+7YCSp+y0HZ5f7ggDsEFKAYvAw2iOnZh1JlBnBIhEJlGNBR/c0pWZosneK;
Message-ID: <40fe3da502608d32ff82523c57a62da1.squirrel@webmail.aber.ac.uk>
Date: Wed, 31 Mar 2010 18:36:08 +0100
Subject: Ftrace and Systemtap
From: swb6@aber.ac.uk
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-UWA-Mid: 1Nx1pp-0000H1-48
X-UWA-Originating-IP: 144.124.16.33
X-UWA-Sophos-Scanned: from swb6@aber.ac.uk virus scanned OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am currently writing up my
dissertation based on dynamic tracing and reducing the learning curve to
understanding the UNIX kernel. I used two dynamic tracing technologies
(Systemtap and Dtrace) to monitor some virtual machines on a network.
Whilst going over my initial review of technologies in the area of dynamic
tracing I realised I had underestimated ftrace, and even dismissed it as
not being dynamic. However I read hear (http://lwn.net/Articles/343766/)
that you were as of July last year trying to introduce a patch that would
allow ftrace the ability to dynamically trace. Also it would be completely
instrumented from the command line without the need to compile a kernel
module al la Systemtap.

My question is do you think Systemtap will be replaced by ftrace in the
future if so I feel I may need to include this fact in my updated
technology review.

Than you for your time
Steve Brown

