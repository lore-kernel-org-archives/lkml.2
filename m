Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0GANP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:15:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab0GANP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:15:57 -0400
Date: Thu, 1 Jul 2010 14:15:47 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chetan Loke <chetanloke@gmail.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, rjones@trick.home.annexia.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       Tzy-Jye Daniel Lin <ephemient@gmail.com>
Subject: Re: [PATCH] virt-what.in: Added VMware virt detection using cpuid
	in wrapper script
Message-ID: <20100701131547.GI6805@amd.home.annexia.org>
References: <AANLkTim1m-HIRMHVIkJLSZitXCh1ZwKh2eAN3UxUxJ1E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim1m-HIRMHVIkJLSZitXCh1ZwKh2eAN3UxUxJ1E@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 07:29:01PM -0400, Chetan Loke wrote:
> Brief discussion thread - http://lkml.org/lkml/2010/6/29/355
> 
> Added VMware detection via cpuid.Mimic'd VMware's balloon driver's init-time
> check(cpuid followed by dmi-checks). Moved the existing logic into a simple
> function to achieve that.
> 
> Tested virt-what.in(ran as a script) and virt-what-cpuid-helper within
> a Linux guest on ESX. Thanks.

Chetan, do you think you could send me this one again as an
attachment.  Some MUA/MTA along the way has sufficiently mangled the
patch such that it can no longer be applied.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://et.redhat.com/~rjones/virt-top
