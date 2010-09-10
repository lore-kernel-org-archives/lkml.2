Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0IJCze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0IJCzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:55:32 -0400
Date: Thu, 9 Sep 2010 22:55:24 -0400
From: Dave Jones <davej@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Serious problem with ticket spinlocks on ia64
Message-ID: <20100910025523.GC31280@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Petr Tesarik <ptesarik@suse.cz>, Tony Luck <tony.luck@intel.com>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201008271537.35709.ptesarik@suse.cz>
 <AANLkTimCOWvBs1pdWeMZD9DR=u2ioFPXt7Jja73VQaZn@mail.gmail.com>
 <201009031104.38433.ptesarik@suse.cz>
 <201009031635.25093.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009031635.25093.ptesarik@suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 04:35:23PM +0200, Petr Tesarik wrote:
 
 > I didn't see values around zero on any other CPU in the system. So, either 
 > there is something seriously broken in hardware, or I made a silly mistake in 
 > the monitoring code.

 ...

 > 	memset(dbr, sizeof dbr, 0);
                    ^^^^^^^^^^^^^
swapped arguments.  Perhaps unrelated to the problem, but still silly :)

	Dave

