Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab0EDP2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:28:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60072 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab0EDP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:28:03 -0400
Date: Tue, 4 May 2010 16:27:24 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100504152724.GA2184@srcf.ucam.org>
References: <20100504004338.GA22678@srcf.ucam.org> <Pine.LNX.4.44L0.1005040949060.1729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005040949060.1729-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 09:51:39AM -0400, Alan Stern wrote:

> Another thing that Kevin is missing: There is more to the system than
> the devices and the CPU.  For example: RAM, an embedded controller (on
> modern desktop/laptop systems), a power supply, and so on.  Dynamic PM
> for the CPU and the devices won't power-down these things, but system
> PM will.

Somewhat true - machines with C1E support will put the RAM into self 
refresh when the cpu is idle, but you're right that there are various 
components that we simply don't have control over in the desktop world 
at present.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
