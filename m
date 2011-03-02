Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1CBMYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:24:02 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33515 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1CBMYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:24:01 -0500
Subject: Re: [ANNOUNCE] The Linux Test Project has been released for
	FEBRUARY 2011.
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Shubham Goyal <shubham@linux.vnet.ibm.com>, ltp-list@lists.sf.net,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, yanegomi@gmail.com, vapier@gentoo.org,
        chrubis@suse.cz
In-Reply-To: <AANLkTikTM7wv0ogVPueLjK391sqaUyekquMXBea0ayFc@mail.gmail.com>
References: <4D6E2C9C.1060404@linux.vnet.ibm.com>
	 <AANLkTikTM7wv0ogVPueLjK391sqaUyekquMXBea0ayFc@mail.gmail.com>
Content-Type: text/plain
Organization: IBM
Date: Wed, 02 Mar 2011 17:53:54 +0530
Message-Id: <1299068635.4463.1.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 13:06 +0100, Paolo Ciarrocchi wrote:
> On Wed, Mar 2, 2011 at 12:40 PM, Shubham Goyal
> <shubham@linux.vnet.ibm.com> wrote:
> > Hi,
> >
> > The Linux Test Project test suite has been released for the month of
> > FEBRUARY 2011. Please see ltp/INSTALL file carefully, as there has
> > been multiple changes for building/installing the test suite after the
> > recent changes in Makefile infrastructure.
> 
> Wouldn't make sense to integrate this test suite in the kernel source tree?

There was discussion like this some few years back. The idea was to get
some core tests from LTP to the kernel source tree. But then the idea
was dropped probably to avoid maintenance overhead ;-)

Regards--
Subrata
 
> 
> Regards,
>        Paolo

