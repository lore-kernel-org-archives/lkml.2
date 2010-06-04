Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0FDAsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:48:10 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40367 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab0FDAsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:48:08 -0400
Date: Fri, 4 Jun 2010 01:47:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 14/26] MIPS: JZ4740: Add Kbuild files
Message-ID: <20100604004741.GA4021@linux-mips.org>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
 <1275505832-17185-6-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275505832-17185-6-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:10:30PM +0200, Lars-Peter Clausen wrote:

> This patch adds the Kbuild files for the JZ4740 architecture and adds JZ4740
> support to the MIPS Kbuild files.

Checkout the changes to the way MIPS platform Makefiles are implemented in
the linux-queue tree.  This new structure will be mandatory for all new
platforms.

  Ralf
