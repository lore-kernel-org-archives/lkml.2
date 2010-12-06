Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0LFWSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:18:02 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34276 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab0LFWSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:18:00 -0500
Date: Mon, 6 Dec 2010 22:17:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        carlos@strangeworlds.co.uk, stable@kernel.org, ceolin@ulevel.com
Subject: Re: [PATCH] wmi: use memcmp instead of strncmp to compare GUIDs
Message-ID: <20101206221750.GA1885@srcf.ucam.org>
References: <1290980810-5903-1-git-send-email-cascardo@holoscopio.com> <20101206220231.GB1139@srcf.ucam.org> <20101206221345.GG4187@barata.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101206221345.GG4187@barata.holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 08:13:46PM -0200, Thadeu Lima de Souza Cascardo wrote:
> On Mon, Dec 06, 2010 at 10:02:31PM +0000, Matthew Garrett wrote:
> > Applied to -next, thanks.
> > 
> > -- 
> > Matthew Garrett | mjg59@srcf.ucam.org
> 
> Hello, Matthew.
> 
> I consider this one a serious bug and with a trivial fix that should go
> to Linus, for the next release candidate. I also consider it should go
> to stable releases, and that's why I'm copying stable.

Sure, I'll pull it back for .37 as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
