Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2G0Bq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:46:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2G0Bqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:46:54 -0400
Date: Thu, 26 Jul 2012 18:46:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, cschamp@vmware.com
Subject: Re: [vmw_vmci 00/11] VMCI for Linux
Message-ID: <20120727014650.GB17168@kroah.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
 <CA+5PVA6RFthz5vjf-0BOogocMEwVKn5uE2q1_frjPFoVeUPACg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6RFthz5vjf-0BOogocMEwVKn5uE2q1_frjPFoVeUPACg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 09:06:25PM -0400, Josh Boyer wrote:
> On Thu, Jul 26, 2012 at 7:39 PM, Andrew Stiegmann (stieg)
> <astiegmann@vmware.com> wrote:
> >  drivers/misc/Kconfig                      |    1 +
> >  drivers/misc/Makefile                     |    1 +
> >  drivers/misc/vmw_vmci/Kconfig             |   16 +
> 
> Is there a reason this isn't going into staging first?  The Hyper-V
> drivers went through staging and that actually seemed to work fairly
> well.

Is there some reason you feel this should be in the staging tree now?
Why?

greg k-h
