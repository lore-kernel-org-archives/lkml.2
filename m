Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0ERUCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:02:40 -0400
Received: from solo.fdn.fr ([80.67.169.19]:33976 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab0ERUCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:02:39 -0400
Date: Tue, 18 May 2010 22:02:36 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hardware Locality (hwloc) v1.0 released
Message-ID: <20100518200236.GA4890@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <20100518162253.GH4960@const.bordeaux.inria.fr> <87aarxxaqk.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87aarxxaqk.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen, le Tue 18 May 2010 21:37:07 +0200, a écrit :
> Samuel Thibault <samuel.thibault@ens-lyon.org> writes:
> 
> > The Hardware Locality (hwloc) team is tremendously pleased to announce the release of version 1.0:
> >
> >    http://www.open-mpi.org/projects/hwloc/ 
> >    (mirrors will update shortly) 
> 
> From a quick look it doesn't seem to offer anything Linux+libnuma+sysfs
> doesn't already offer natively? 

It does provide a uniform way to express it, as a tree.  And it does so
the same way on all supported OSes.

As an aside, it provides a portable way to bind processes & threads,
which PLPA was already meant to do on Linux itself only according to
glibc versions...

Samuel
