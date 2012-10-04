Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2JDBzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:55:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40643 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2JDBzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:55:50 -0400
Date: Thu, 4 Oct 2012 02:55:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121004015539.GA19958@srcf.ucam.org>
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
 <20121003164712.GF2527@linux.vnet.ibm.com>
 <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
 <20121003200314.GR2527@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003200314.GR2527@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 01:03:14PM -0700, Paul E. McKenney wrote:

> That has not proven sufficient for me in the past, RCU_FAST_NO_HZ
> being a case in point.

Taint the kernel at boot time? That'd be sufficient to force distros to 
disable it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
