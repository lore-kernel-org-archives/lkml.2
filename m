Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2IYXGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:06:38 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34449 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2IYXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:06:37 -0400
Message-ID: <1348614392.17507.5.camel@concerto.americas.hpqcorp.net>
Subject: Re: [PATCH -next v2] Shorten constant names for EFI variable
 attributes
From: Khalid Aziz <khalid.aziz@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Garrett <mjg@redhat.com>, hpa@zytor.com, keescook@chromium.org,
        tony.luck@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        cbouatmailru@gmail.com, ccross@android.com,
        paul.gortmaker@windriver.com, maxin.john@gmail.com,
        matt.fleming@intel.com, olof@lixom.net, dhowells@redhat.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        khalid@gonehiking.org
Date: Tue, 25 Sep 2012 17:06:32 -0600
In-Reply-To: <20120926075528.e497436227403ecaf1b845d3@canb.auug.org.au>
References: <20120720220841.GA32642@hp.com> <5009D770.1050905@zytor.com>
	 <20120723132656.GC21495@srcf.ucam.org> <50117E40.8090904@hp.com>
	 <20120726173332.GA19851@srcf.ucam.org>
	 <20120925154100.GA13412@ldl.usa.hp.com>
	 <20120926075528.e497436227403ecaf1b845d3@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 07:55 +1000, Stephen Rothwell wrote:
> Hi,
> 
> On Tue, 25 Sep 2012 09:41:00 -0600 Khalid Aziz <khalid.aziz@hp.com> wrote:
> >
> > Replace very long constants for EFI variable attributes with
> > shorter and more convenient names. Also create an alias for
> > the current longer names so as to not break compatibility
> > with current API since these constants are used by
> > userspace programs.
> 
> Why do this?  It just looks like churn for no real gain.
> 

This is for code cleanup and does not impact functionality. This is
based upon an earlier discussion -
<https://lkml.org/lkml/2012/7/13/320>. The goal is to make the code more
readable. V1 of this patch was discussed at
<https://lkml.org/lkml/2012/7/20/414>.

-- 
Khalid Aziz <khalid.aziz@hp.com>

