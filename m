Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2GQUkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:40:08 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56947 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2GQUkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:40:05 -0400
Date: Tue, 17 Jul 2012 13:40:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next] mei: use module_pci_driver
Message-ID: <20120717204001.GA18021@kroah.com>
References: <1342513427-10076-1-git-send-email-tomas.winkler@intel.com>
 <20120717171726.GA7538@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B13C2CD@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B13C2CD@HASMSX103.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 08:04:06PM +0000, Winkler, Tomas wrote:
> 
> > This patch fails to apply to my tree :(
> 
> Right, my mistake I haven't checked it directly with your tree,  I
> need to wait till you merge the upstream in. 

Merge what "upstream"?

greg k-h
