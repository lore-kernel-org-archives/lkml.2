Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1DLN0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:26:12 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:61716 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab1DLN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:26:08 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJjS0MFZE=
X-RZG-CLASS-ID: mo00
Date: Tue, 12 Apr 2011 15:26:03 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Greg KH <greg@kroah.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hv: Reduce indention in vmbus_on_event
Message-ID: <20110412132603.GA25917@aepfle.de>
References: <20110322210207.GA17724@aepfle.de>
 <20110405050848.GA8330@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110405050848.GA8330@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, Greg KH wrote:

> On Tue, Mar 22, 2011 at 10:02:07PM +0100, Olaf Hering wrote:
> > Reduce indention in vmbus_on_event() by converting two
> > if (var) to if (!var)
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> This, and I think your other ones in this series, no longer applies due
> to changes made by others to this driver.
> 
> Can you resync off of the next linux-next release and resend the
> patches?  I'd also like to get an ack or tested-by or something from
> Hank and the other developers of these drivers before accepting them.

Yes, I will look at it this in the next days.

Olaf
