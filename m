Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2EWGRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:17:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2EWGRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:17:17 -0400
Date: Tue, 22 May 2012 23:17:12 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Lalit Chandivade <lalit.chandivade@qlogic.com>,
        Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: Bug in sysfs bin attribute?
Message-ID: <20120523061712.GA19773@kroah.com>
References: <CBE2759B.EEFF%vikas.chaudhary@qlogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CBE2759B.EEFF%vikas.chaudhary@qlogic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:38:11PM -0700, Vikas Chaudhary wrote:
> 
> We have added sysfs bin_attribute 'fw_dump' in qla4xxx driver.
> Here is patch for same: -
> http://marc.info/?l=linux-scsi&m=133733192809849&w=2
> 
> 
> In this patch in function qla4_8xxx_sysfs_write_fw_dump() if we print
> string coming in 'char *buf'
> from sysfs attribute it contain value we echo on sysfs attribute 'fw_dump'
> plus some garbage data.

Why are you not using the built-in firmware interface the kernel
provides you?  What does it lack that you need here?

greg k-h
