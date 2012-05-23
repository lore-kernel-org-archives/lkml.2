Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab2EWVkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:40:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50100 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2EWVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:40:22 -0400
Date: Thu, 24 May 2012 00:43:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: comedi: adl_pci7296: factor out the PCI device
 code
Message-ID: <20120523214354.GQ4637@mwanda>
References: <201205231428.48061.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205231428.48061.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hartley, you're doing a great job with all these patches, but it's
going to be weeks before the merge window closes.  We're going to
end up getting confused with all the patches floating around.

Do you think you could maybe put up a git tree with the current
stuff so people know when they're stepping on each other's toes?

regards,
dan carpenter
