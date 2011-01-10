Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1AJODs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:03:48 -0500
Received: from gherkin.frus.com ([192.158.254.49]:44724 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1AJODr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:03:47 -0500
Date: Mon, 10 Jan 2011 08:03:44 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH] i2c-i801: Add missing <linux/slab.h> include.
Message-ID: <20110110140344.GA23957@gherkin.frus.com>
References: <20110104141151.b6035bf3.randy.dunlap@oracle.com> <1294634675-29557-1-git-send-email-mcree@orcon.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294634675-29557-1-git-send-email-mcree@orcon.net.nz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 05:44:35PM +1300, Michael Cree wrote:
> Causes compile error on Alpha, but not on x86 because its version
> of <asm/pci.h> includes <linux/slab.h>.  In any case, it's a bug
> in the driver.
> 
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>

ACK.  Works for me.

--Bob
