Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab0FPUWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:22:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53227 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0FPUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=onQhtUwFEKP0JnSJVL41PWe1cs/V+hsBUkYCphdN57srbyIKrF192BcVr9jPzXcANR
         ny+/oC5WH7HzPGc1YhIJT4WuQ2NgkdnXCFrdBZQ1gplPpujccusoP3KaD1xO5PnVnjzi
         0Lmyh4hmgbPPtn6MX7Vd17QNZPpq+rt0ARYlo=
Date: Wed, 16 Jun 2010 12:28:04 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: John Sheehan <john.d.sheehan@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, rich.folsom@gmail.com,
       mithlesh@linsyssoft.com, jirislaby@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: fix style errors in adl_pci9111.c
Message-ID: <20100616192803.GA11073@fujitsu>
References: <1276713009-8499-1-git-send-email-john.d.sheehan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276713009-8499-1-git-send-email-john.d.sheehan@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 16, 2010 at 07:30:09PM +0100, John Sheehan wrote:
> From: John Sheehan <john.d.sheehan@gmail.com>

> @@ -190,7 +190,7 @@ TODO:
>    outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
>  
>  #define pci9111_interrupt_and_fifo_get() \
> -  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) &0x03)
> +  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4)&0x03)

Doesn't checkpatch.pl suggest to add a whitespace after the & in that case?
It would seem more readable.

-- 
Charles Clément

