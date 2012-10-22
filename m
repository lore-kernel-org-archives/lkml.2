Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2JVRnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:43:53 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:19877 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2JVRnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:43:52 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 13:43:52 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=IpWcbwJXJHdct0ARIdQJ9hdiEcPVGEj/cKClqoUVge8xFa105SCxMcFBkE/a
	Z1FzfpQGC+xwkXig8RctykJXBkvbjeyamoBP6D2/ARToMryLk3hmPGMGX
	iiy3tLIbXsFLS6xwDpFrcwDLVsgIkhGGgkbuMggPQhIdNR4xf/FgNk=;
X-Spam-Processed: mail.digidescorp.com, Mon, 22 Oct 2012 12:37:02 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16424020ab=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
Message-ID: <1350927423.4238.5.camel@iscandar.digidescorp.com>
Subject: Re: usbview 2.0 release
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Anil Nair <anilcoll90@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2012 12:37:03 -0500
In-Reply-To: <CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
References: <20121022162140.GA10021@kroah.com>
	 <CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anil -

On Mon, 2012-10-22 at 22:49 +0530, Anil Nair wrote: 
> Hello Greg,
> 
> But while compiling it i am getting an error,
> 
> "checking for GTK... no
> configure: error: Package requirements (gtk+-3.0 >= 3.0) were not met:
> 
> No package 'gtk+-3.0' found
... 
> The OS i am using is ubuntu-11.10 amd64.

I can't speak for Ubuntu, but on Fedora installing gtk3-devel eliminated
the message you describe.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>



