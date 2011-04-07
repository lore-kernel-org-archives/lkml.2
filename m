Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1DGWU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:20:29 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37220 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755591Ab1DGWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:20:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fWLf28XK44yPsusCCfFFR/hon599Kb3QwhPmugT6LGyME7C/vwZwEXpIbodlMoYrqtDlm3M+tTLbl86gJXBqXLIhpNSv5FwlN38Pvvx0NydD1NRESdYspz5zk06xFfHA;
Date: Thu, 7 Apr 2011 15:20:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ameya Palande <ameya.palande@nokia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add Documentation/leds/00-INDEX
Message-Id: <20110407152025.4ae45c59.rdunlap@xenotime.net>
In-Reply-To: <4D9ADA58.9050806@nokia.com>
References: <20110331084420.47eaa91c.rdunlap@xenotime.net>
	<1301648314-3441-1-git-send-email-ameya.palande@nokia.com>
	<20110401101701.e440ad6d.rdunlap@xenotime.net>
	<4D9ADA58.9050806@nokia.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 12:01:12 +0300 Ameya Palande wrote:

> Hi Randy,
> 
> On 04/01/2011 08:17 PM, ext Randy Dunlap wrote:
> > On Fri,  1 Apr 2011 11:58:34 +0300 Ameya Palande wrote:
> >
> >> Signed-off-by: Ameya Palande<ameya.palande@nokia.com>
> >
> > Applied, thanks.
> >
> >> ---
> >>   Documentation/leds/00-INDEX |   10 ++++++++++
> >>   1 files changed, 10 insertions(+), 0 deletions(-)
> >>   create mode 100644 Documentation/leds/00-INDEX
> >>
> >> diff --git a/Documentation/leds/00-INDEX b/Documentation/leds/00-INDEX
> >> new file mode 100644
> >> index 0000000..762d676
> >> --- /dev/null
> >> +++ b/Documentation/leds/00-INDEX
> >> @@ -0,0 +1,10 @@
> >> +00-INDEX
> >> +	- This file
> >> +leds-class.txt
> >> +	- Info about led sysfs class
> >> +leds-lp3944.txt
> >> +	- Info on National Semiconductor LP3944 fun-light chip
> >> +leds-lp5521.txt
> >> +	- Info on National Semiconductor LP5521 led driver chip
> >> +leds-lp5523.txt
> >> +	- Info on National Semiconductor LP5523 led driver chip
> >> --
> 
> Can you point me to your tree where you applied my commit?

See MAINTAINERS file:

DOCUMENTATION
M:	Randy Dunlap <rdunlap@xenotime.net>
L:	linux-doc@vger.kernel.org
T:	quilt oss.oracle.com/~rdunlap/kernel-doc-patches/current/
S:	Maintained
F:	Documentation/



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
