Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2AaExt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:53:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37940 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2AaExs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:53:48 -0500
Date: Mon, 30 Jan 2012 20:53:44 -0800
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120131045344.GA27609@quad.lixom.net>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 02:35:54PM -0700, Grant Likely wrote:
> Hey everyone,
> 
> This patch series is ready for much wider consumption now.  I'd like
> to get it into linux-next ASAP because there will be ARM board support
> depending on it.  I'll wait a few days before I ask Stephen to pull
> this in.
> 
> Stephen/Milton/Ben, any testing you can help with here would be
> appreciated since you've got access to a wider variety of Power
> machines than I do.

This series has been:

Tested-by: Olof Johansson <olof@lixom.net>

On powerpc/pasemi (it's the only one I still have easy access to).


-Olof
