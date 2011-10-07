Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935926Ab1JGJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1JGJ2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:28:23 -0400
Date: Fri, 7 Oct 2011 11:28:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111007092819.GJ8203@redhat.com>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930235924.GA25176@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 04:59:24PM -0700, Greg KH wrote:
>    If you have a source-based system (Gentoo, LFS, etc.) you presumably
>    know what you are doing already.

Gentoo portage updates through mirrors by default are insecure and I'm
not sure everyone knows what's doing already considering it's not the
default and if I talk to people they're not aware about it. So I
thought it's appropriate to send a reminder considering your topic...

To be secure if you use Gentoo you need to add webrsync-gpg to
FEATURES in make.conf and then use only emerge-webrsync (and never use
emerge --sync). Then you should be safe, after that the
SHA1/SHA256/RMD160 of every further download is verified against the
Manifests which have been cryptographically signed. It's very naive
and too insecure to trust any random mirror and emerge --sync should
be abolished and webrsync-gpg should be the default in FEATURES. After
you see "Good signature from" in output from emerge-webrsync you
should be safe. tarsync then speed things up.
