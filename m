Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab2JZCpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 22:45:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50028 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2JZCpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 22:45:17 -0400
Date: Thu, 25 Oct 2012 19:45:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: Phil Turmel <philip@turmel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Andrew Morton <akpm@linux-foundation.org>, Chris Ball <cjb@laptop.org>,
        "oakad@yahoo.com" <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v6 0/3] Add modules to support realtek PCIE card reader
Message-ID: <20121026024556.GA9545@kroah.com>
References: <cover.1347330871.git.wei_wang@realsil.com.cn>
 <50664814.30407@turmel.org>
 <20120929110730.GA27797@liondog.tnic>
 <87d315osjm.fsf@octavius.laptop.org>
 <20120929152942.GA11412@liondog.tnic>
 <506FDC8C.3030707@realsil.com.cn>
 <20121020034615.GT5685@mwanda>
 <20121025185041.GB22114@kroah.com>
 <5089E315.1010708@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5089E315.1010708@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 09:10:45AM +0800, wwang wrote:
> 于 2012年10月26日 02:50, Greg KH 写道:
> > On Sat, Oct 20, 2012 at 06:46:15AM +0300, Dan Carpenter wrote:
> >> On Sat, Oct 06, 2012 at 03:23:56PM +0800, wwang wrote:
> >>> We are still maintaining the SCSI driver for Realtek card reader,
> >>> and will release the latest source code in the Github in the future.
> >>> But maybe we won't push it to the staging tree any more.
> >> Maybe we should just remove the staging code if it won't be fixed.
> >> That's sort of the point of staging.
> > I agree.  wwang, want me to delet the staging driver now?  I don't want
> > "dead" code in the tree, especially as you don't want to maintain it
> > anymore.
> >
> > thanks,
> >
> > greg k-h
> Hi Greg:
> 
> OK. You can delete it now, please.
> And I will push my new driver to MFD and MMC subsystem.

Ok, just to confirm, you want me to delete the
drivers/staging/rts_pstor/* code, right?

thanks,

greg k-h
