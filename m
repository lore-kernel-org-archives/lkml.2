Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2JVR6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:58:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55720 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab2JVR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:58:40 -0400
Date: Mon, 22 Oct 2012 10:59:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Nair <anilcoll90@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: usbview 2.0 release
Message-ID: <20121022175907.GA19113@kroah.com>
References: <20121022162140.GA10021@kroah.com>
 <CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
 <1350927423.4238.5.camel@iscandar.digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350927423.4238.5.camel@iscandar.digidescorp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 12:37:03PM -0500, Steven J. Magnani wrote:
> Anil -
> 
> On Mon, 2012-10-22 at 22:49 +0530, Anil Nair wrote: 
> > Hello Greg,
> > 
> > But while compiling it i am getting an error,
> > 
> > "checking for GTK... no
> > configure: error: Package requirements (gtk+-3.0 >= 3.0) were not met:
> > 
> > No package 'gtk+-3.0' found
> ... 
> > The OS i am using is ubuntu-11.10 amd64.
> 
> I can't speak for Ubuntu, but on Fedora installing gtk3-devel eliminated
> the message you describe.

Yes, that is required.  Anil, let me know if you have that type of
package installed, and if after doing so, you still get the same error.

thanks,

greg k-h
