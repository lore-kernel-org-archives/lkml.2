Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1JYHfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:35:02 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53788 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab1JYHfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:35:00 -0400
X-Sasl-enc: //mWrFreGxwLuQRC7WLNxkFMn7soSa4PmkMd27UzE40Z 1319528099
Date: Tue, 25 Oct 2011 09:34:54 +0200
From: Greg KH <greg@kroah.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
Message-ID: <20111025073454.GA14967@kroah.com>
References: <4EA3F7C0.24E469C5@users.sourceforge.net>
 <20111023113727.GA24285@kroah.com>
 <4EA41FB7.CB5369CF@users.sourceforge.net>
 <20111025014911.GC22764@kroah.com>
 <11749.1319527717@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11749.1319527717@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 03:28:37AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 25 Oct 2011 03:49:11 +0200, Greg KH said:
> 
> > The real check, to verify that this tarball really came from "me" should
> > be done on the uncompressed tarball, which is what I can sign, and it is
> > something that you, or anyone else, can reliable duplicate on their own
> > by just using git and not even downloading the tarball at all.
> 
> I'm OK on that part..
> 
> > In other words, we just saved you a MASSIVE bandwidth transation for all
> > of your future kernel downloads, and you can reliable know that the
> > tarball you have in your system is what is on the kernel.org servers
> > without you even having to download it yourself and run those
> > decompression tools that you don't trus.
> 
> If you're building an automated process that will take a just-uploaded foo.tar
> and generate foo.tar.{bz2,gz,foozip}, can you add a step that would just do an
> 'md5sum foo.tar.* > foo.tar.sums'?  Or sha256sum if you're worried about the
> crypto weakness issues with MD5. Personally, I'm more interested in the "Did  I
> hit a network error that the TCP checksum didn't catch?" case.

Yes, we are working on just that thing, and the foo.tar.sums file will
be signed with the kernel.org "throwaway" key, so you can check that as
well.

greg k-h
