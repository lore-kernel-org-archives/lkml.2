Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1AXPwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:52:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58670 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1AXPwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:52:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I+EG9Sjt+bul68XSD6+QJ7x7sApl1sO0AEIFo19OoaIBJ/IgP9TMnDoXupA7uNnmbx
         VLLpDBy8c/+ZiJ4Vddk7Csf6vuilxR1tVv+CBas9+b2D9f2xTK8r6DKFWZdkD4nVadpQ
         /48sPLriSRdHsM7nazhXvr/T80UIJSKrgCc6Q=
Date: Mon, 24 Jan 2011 16:52:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ryan Wilson <hap9@epoch.ncsc.mil>, Jan Beulich <JBeulich@novell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] xen-pcifront: don't use flush_scheduled_work()
Message-ID: <20110124155241.GB27510@htj.dyndns.org>
References: <20110124144303.GG11404@htj.dyndns.org>
 <20110124153958.GA1222@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124153958.GA1222@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, missed the later part.

On Mon, Jan 24, 2011 at 10:39:58AM -0500, Konrad Rzeszutek Wilk wrote:
> > -	/*For PCIE_AER error handling job*/
> 
> Any reason for getting rid of the comment?
> 
> > -	flush_scheduled_work();
> > +	cancel_work_sync(&pdev->op_work);

Because it's obvious from the code now.  If you think it's better to
keep the comment, I have no objection whatsoever.

Thank you.

-- 
tejun
