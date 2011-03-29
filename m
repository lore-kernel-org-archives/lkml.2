Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1C2HS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:18:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47419 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750878Ab1C2HS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:18:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19a2z5NnyJap2QpCZYVZHo/I5CML8y9ve/q7tm7+x
	jw9UD2BpmMHR+X
Subject: Re: show autogroup cgroups using cgroup fs?
From: Mike Galbraith <efault@gmx.de>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110329070215.GA6650@comet.dominikbrodowski.net>
References: <20110329070215.GA6650@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 09:18:22 +0200
Message-ID: <1301383102.14310.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 09:02 +0200, Dominik Brodowski wrote:
> Hey,
> 
> is there a way to display the autogroup-created cgroups using the cgroup
> filesystems? 

Nope, there are no autogroup-created cgroups.  Autogroup has nothing
other than infrastructure usage in common with cgroups.

	-Mike

