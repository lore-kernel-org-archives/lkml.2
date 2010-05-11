Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0EKOGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:06:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892Ab0EKOGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:06:30 -0400
Date: Tue, 11 May 2010 07:05:47 -0700
From: Greg KH <gregkh@suse.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: return correct value when writing to the "reset"
 attribute
Message-ID: <20100511140547.GA13575@suse.de>
References: <20100511094453.12485.43792.stgit@leela.lan>
 <20100511105859.GA2295@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511105859.GA2295@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 01:58:59PM +0300, Michael S. Tsirkin wrote:
> On Tue, May 11, 2010 at 11:44:54AM +0200, Michal Schmidt wrote:
> > A successful write() to the "reset" sysfs attribute should return the
> > number of bytes written, not 0. Otherwise userspace (bash) retries the
> > write over and over again.
> > 
> > Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
