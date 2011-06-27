Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1F0Qvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:51:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34823 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1F0Qvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:51:33 -0400
Date: Mon, 27 Jun 2011 12:51:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bastian Blank <waldi@debian.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 2/2] xen: Add alias to autoload backend
 drivers
Message-ID: <20110627165109.GB13335@dumpdata.com>
References: <20110624215155.GB4735@wavehammer.waldi.eu.org>
 <20110627161327.GO6978@dumpdata.com>
 <20110627163728.GA23028@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627163728.GA23028@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E08B508.013B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 06:37:29PM +0200, Bastian Blank wrote:
> On Mon, Jun 27, 2011 at 12:13:27PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jun 24, 2011 at 11:51:55PM +0200, Bastian Blank wrote:
> > > All the Xen backend drivers are assigned to a special bus type
> > > xen-backend. This allows userspace to load the modules on request.
> > Is there a specific version of udev that would take advantage of this?
> 
> Was there a version within the last three years that can't? The patch is
> tested and udev does its work.

Ok, that answers that question. Queue up for 3.1
