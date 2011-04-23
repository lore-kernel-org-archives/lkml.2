Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1DWSdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:33:16 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:50752 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752849Ab1DWSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:33:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=f1b6JEsOBy+ReOVH6c/fZNW5TvYHJrqoqOcB0SFqzgEkz5dJXhFm2vmSf/BMU1VTr1B+G4e0Aw8N2B34jBooqd2cC1Dxle83uSOgMJ+iIT3ByQqcagcc31Wh+i55ZGTX;
Date: Sat, 23 Apr 2011 11:33:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Cyril Brulebois <kibi@debian.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help
 keeping the index up-to-date
Message-Id: <20110423113312.864422c4.rdunlap@xenotime.net>
In-Reply-To: <20110423171522.GF32680@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
	<1303575344-10403-3-git-send-email-kibi@debian.org>
	<20110423093304.8a31e512.rdunlap@xenotime.net>
	<20110423171522.GF32680@debian.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 19:15:22 +0200 Cyril Brulebois wrote:

> Randy Dunlap <rdunlap@xenotime.net> (23/04/2011):
> > but what am I doing wrong?
> > 
> > cd Documentation
> > sh ./00-INDEX.sh
> > 
> > The "undocumented" list looks correct (well, it could omit .orig files),
> > but the "Documented but missing" list contains words, e.g.:
> 
> Looks like sed's not filtering out lines before '00-INDEX'; my reading
> of POSIX sed specification[1] would seem to confirm the filtering
> should work, see:
>     [2addr]d
>     Delete the pattern space and start the next cycle.
> 
>  1. http://pubs.opengroup.org/onlinepubs/007908799/xcu/sed.html
> 
> Maybe some regex fun then; what if you remove the anchors (^ and $)?
> 
> And anyway, using sed --posix to disable all GNU extensions gives the
> expected output here (with GNU sed version 4.2.1).
> 
> What's your sed/system, so that I can check what's going on there, and
> how to deal with it?

Fedora 11 and
> sed --version
GNU sed version 4.2.1


> Using 'grep -A $ABIGNUMBER' could be a workaround I guess, but a ugly
> one…


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
