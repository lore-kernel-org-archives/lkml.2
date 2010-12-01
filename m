Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab0LASrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:47:31 -0500
Received: from claw.goop.org ([74.207.240.146]:47850 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab0LASra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:47:30 -0500
Message-ID: <4CF69840.3040704@goop.org>
Date: Wed, 01 Dec 2010 10:47:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 0/5] Xen PV on HVM fixes
References: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 10:22 AM, Stefano Stabellini wrote:
> Hi all,
> this patch series is a collection of fixes for Xen PV on HVM.
>
> The first two patches fix two pirq remapping problems with MSIs, they
> have been sent to the list few times already for comments.
> The three following patches are new and fix save/restore bugs.

Are you targeting these at 3.6.37-rc?  If so, each changelog commit
should explicitly say what bug is being fixed, and what the impact of
the bug is.  The last 3 are OK, but it isn't clear to me whether the
first two are strictly bugfixes or not.

    J
