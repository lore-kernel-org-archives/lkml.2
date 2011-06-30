Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab1F3RHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:07:32 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44388 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752005Ab1F3RHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:07:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rogPOYpZGGl+F/KLlQ460soK3ZnFPxPIdjSB59xtQB9oopJnThRbkod6zEqpyA5K956ggbokI5N4Iy/fy4Qh4nOAhpb+4VaEvY05/AjhHN+0oxxweR0JURNvoe+cKeiV;
Date: Thu, 30 Jun 2011 10:07:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Ram Pai <linuxram@us.ibm.com>, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
Message-ID: <20110630100705.2d65656c@jbarnes-desktop>
In-Reply-To: <4E0CACB7.7040709@hartkopp.net>
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
	<4E0CACB7.7040709@hartkopp.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 19:04:55 +0200
Oliver Hartkopp <socketcan@hartkopp.net> wrote:

> On 30.06.2011 10:09, Ram Pai wrote:
> > Multiple attempts to dynamically reallocate pci resources have unfortunately
> > lead to regressions. Though we continue to fix the regressions and fine tune the
> > dynamic-reallocation behavior, we have not reached a acceptable state yet.
> > 
> > This patch provides a interim solution. It disables dynamic-reallocation; by
> > default, with the ability to enable it through pci=realloc kernel command line
> > parameter.
> 
> What is the advantage of creating an 'interim' kernel parameter instead of
> reverting the problematic commit and queue up a proper solution for 3.1 ?
> 
> A kernel parameter needs to be observed, documented and set appropriately.
> 
> I would prefer to have an automatic solution - if not in 3.0 then in 3.1 ...

Yeah, we all want an automatic solution, but we still haven't been able
to achieve one.  My hope is that a parameter will let us keep the code
upstream for Ram and others to keep fixing, then we can move to using
it by default in some future release.  Keeping the code upstream but
behind a param should make development easier; at least that's the goal.

-- 
Jesse Barnes, Intel Open Source Technology Center
