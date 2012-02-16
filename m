Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2BPAK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:10:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53120 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab2BPAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:10:56 -0500
X-Sasl-enc: /sAx+K5a3qJQ2tp8YfgnEkfWkJqSEnxpwuAU4TBx52ef 1329351055
Date: Wed, 15 Feb 2012 16:10:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Egmont Koblinger <egmont@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
Message-ID: <20120216001040.GA21919@kroah.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
 <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
 <CAOULuObKZX_VER0ERPNBb0gS8GBQBHpJBHQcpJi2kNBBysL=2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOULuObKZX_VER0ERPNBb0gS8GBQBHpJBHQcpJi2kNBBysL=2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 06:58:12PM -0500, Parag Warudkar wrote:
> On Wed, Feb 15, 2012 at 1:50 PM, Egmont Koblinger <egmont@gmail.com> wrote:
> > Hi,
> >
> > Short summary:  When pasting large amount of data (>4kB) to terminals,
> > often the data gets mangled.
> >
> > How to reproduce:
> > Create a text file that contains this line about 100 times:
> > a=(123456789123456789123456789123456789123456789123456789123456789)
> > (also available at http://pastebin.com/LAH2bmaw for a while)
> > and then copy-paste its entire contents in one step into a "bash" or
> > "python" running in a graphical terminal.
> >
> 
> FWIW, this also works fine on cygwin / Windows 7.  No errors.
> 
> $ bash --version
> GNU bash, version 4.1.10(4)-release (i686-pc-cygwin)
> 
> Unsure what that means though - probably nothing!
> 
> Greg - when you said it works in vim - since of course vim isn't
> 'parsing' the input may be you did not see an error - or did you
> actually verify all 4KB somehow? ;)

I verified that the input actually matched the paste buffer.  It's
pretty trivial to do so.

Odds are emacs also does this correctly, anyone care to verify that?

thanks,

greg k-h
