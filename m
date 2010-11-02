Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0KBTkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:40:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0KBTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=G9rKkFu7s5EOzOcXgbwuyR6EtccL1J9d3PQHajiPSJ3cznSaI2HoC6TN6ORNRvNlh/
         N69T+zwwwv1/jhAItjTA==
Date: Tue, 2 Nov 2010 12:39:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Gamari <bgamari.foss@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
In-Reply-To: <87oca7evbo.fsf@gmail.com>
Message-ID: <alpine.DEB.2.00.1011021235130.21387@chino.kir.corp.google.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com> <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com> <87oca7evbo.fsf@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010, Ben Gamari wrote:

> > And they can't use an init script to tune /proc/sys/vm/swappiness 
> > because...?
> 
> Packaging concerns, as I mentioned before,
> 

That you snipped from the changelog?

> On Mon, Nov 01, 2010 at 08:52:30AM -0400, Ben Gamari wrote:
> > Ubuntu ships different kernels for desktop and server usage. From a
> > packaging standpoint it would be much nicer to have this set in the
> > kernel configuration. If we were to throw the setting /etc/sysctl.conf
> > the kernel would depend upon the package containing sysctl(8)
> > (procps). We'd rather avoid this and keep the default kernel
> > configuration in one place.
> 
> In short, being able to specify this default in .config is just far
> simpler from a packaging standpoint than the alternatives.
> 

You could say the same thing for any sysctl, it's not indicative of why 
this particular change is needed in the kernel.

Let's not have the "in short" answer, what's the "long" answer?
