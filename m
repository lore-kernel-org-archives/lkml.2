Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433Ab2EXV1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:27:31 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42698 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932464Ab2EXV12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:27:28 -0400
X-Sasl-enc: PLzZdNhJ2O1bOFFDutDh4gmrBPWMDo+CQMSsDNr4acoT 1337894846
Date: Fri, 25 May 2012 04:11:15 +0900
From: Greg KH <greg@kroah.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@vger.kernel.org, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Steven Williamson <steven.williamson@dialogue.net>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
        stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com,
        akpm@linux-foundation.org
Subject: Re: [3.0.y, 3.2.y, 3.3.y] Re: [PATCH 05/10] hpsa: Fix problem with
 MSA2xxx devices
Message-ID: <20120524191115.GB14713@kroah.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
 <20120119200104.17835.29536.stgit@beardog.cce.hp.com>
 <20120520094735.GA14683@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120520094735.GA14683@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 04:47:35AM -0500, Jonathan Nieder wrote:
> Hi Greg and Ben,
> 
> Please consider
> 
>   9bc3711cbb67 [SCSI] hpsa: Fix problem with MSA2xxx devices
> 
> for application to next week's 3.0.y, 3.2.y, and 3.3.y trees.

Now applied to the 3.0.y and 3.3.y trees, thanks.

greg k-h
