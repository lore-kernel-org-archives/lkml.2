Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1AEWnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:43:51 -0500
Received: from kroah.org ([198.145.64.141]:59918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab1AEWnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:43:42 -0500
Date: Wed, 5 Jan 2011 14:43:06 -0800
From: Greg KH <greg@kroah.com>
To: Tsozik <tsozik@yahoo.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and
 _get_icount functions
Message-ID: <20110105224306.GB18452@kroah.com>
References: <87086.58416.qm@web65703.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87086.58416.qm@web65703.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 12:55:38PM -0800, Tsozik wrote:
> Pete,
> 
> You're absolutely right. My apology again, I re-checked values of MSR masks used to update icount counters and they all belong to upper MSR nibble, so they indeed track changes (not states). I took out counter increments from mct_u232_msr_to_state function and encapsulated them in the newly defined mct_u232_msr_to_icount function, effectively leaving the previous implementation of mct_u232_msr_to_state function intact. mct_u232_msr_to_icount uses delta nibble to track state changes. RM-60 testing showed the same levels as measured by PDM-2 in close proximity to RM-60. Please let me know if anything else needs to be corrected to roll this out,

Can you not attach the patch as a base64 attachment?  I can't apply it
as-is, because of that, sorry.

thanks,

greg k-h
