Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1ADRTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:19:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:38711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1ADRTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:19:49 -0500
Subject: Re: [RFC -v3 PATCH 0/3] directed yield for Pause Loop Exiting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1294136809.4379.4.camel@marge.simson.net>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <4D22E4F9.4060909@redhat.com>  <1294136809.4379.4.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 18:20:05 +0100
Message-ID: <1294161605.2016.176.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 11:26 +0100, Mike Galbraith wrote:
> On Tue, 2011-01-04 at 11:14 +0200, Avi Kivity wrote:
> 
> > Assuming there are no objections, Mike, can you get 2/3 into a 
> > fast-forward-only branch of tip.git?  I'll then merge it into kvm.git 
> > and apply 1/3 and 2/3.
> 
> Wrong guy.  Fast-forward is Peter's department.

Right, let me have a look, I put this thread on pause for a while, need
to catch up.
