Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1BOPiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:38:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1BOPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:38:00 -0500
Date: Tue, 15 Feb 2011 10:37:58 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: Bret Towe <magnade@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/nfsd/nfs4state.c
Message-ID: <20110215153757.GA16486@pad.home.fieldses.org>
References: <AANLkTinW7mWsrgwY2JsG9U-Qk1icKyApbdVJvavw4iGZ@mail.gmail.com>
 <20110215011102.GA14825@pad.home.fieldses.org>
 <AANLkTim_Xaik8enPNhs+x8+dBQ2Ya+fSpYP534LkpitT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim_Xaik8enPNhs+x8+dBQ2Ya+fSpYP534LkpitT@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 09:04:31PM -0800, Bret Towe wrote:
> On Mon, Feb 14, 2011 at 5:11 PM, J. Bruce Fields <bfields@redhat.com> wrote:
> > On Sun, Feb 13, 2011 at 02:12:06PM -0800, Bret Towe wrote:
> >> got this bug shortly after a fresh boot into 2.6.38-rc4 a nfs client
> >> at the time was logging into its nfs home
> >> the server is a 32bit setup running debian squeeze
> >> the client at the time was 64bit debian squeeze (also running 2.6.38-rc4)
> >> and the output below is from the server
> >>
> >> let me know if you need more info and I can do tests if required
> >
> > This is a known bug.  It should be fixed in
> >
> >        git://linux-nfs.org/~bfields/linux.git for-2.6.38
> >
> > --b.
> >
> 
> yeah looks to be fixed nfs client is able to login and have done some
> other minor
> things and see no errors

Good, thanks for the report.

--b.
