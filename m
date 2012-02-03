Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2BCTue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:50:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2BCTuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:50:32 -0500
Date: Fri, 3 Feb 2012 11:50:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/6] ipmi: Increase KCS timeouts
Message-Id: <20120203115026.9e2a357f.akpm@linux-foundation.org>
In-Reply-To: <1328284079-5489-2-git-send-email-cminyard@mvista.com>
References: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
	<1328284079-5489-2-git-send-email-cminyard@mvista.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Feb 2012 09:47:55 -0600
Corey Minyard <cminyard@mvista.com> wrote:

> From: Matthew Garrett <mjg@redhat.com>
> 
> We currently time out and retry KCS transactions after 1 second of waiting
> for IBF or OBF. This appears to be too short for some hardware. The IPMI
> spec says "All system software wait loops should include error timeouts. For
> simplicity, such timeouts are not shown explicitly in the flow diagrams. A
> five-second timeout or greater is recommended". Change the timeout to five
> seconds to satisfy the slow hardware.

Several of these patches fix bugs/problems, but there isn't enough info
here for me to decide whether we should patch 3.3 or earlier kernels. 
I'm assuming "3.4 only".

> From: Matthew Garrett <mjg@redhat.com>

A dupe.  The first one was correct.
