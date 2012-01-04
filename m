Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2ADPP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:15:58 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28375 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2ADPP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:15:56 -0500
Date: Wed, 4 Jan 2012 10:12:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Haogang Chen <haogangchen@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/2] xen/xenbus: don't reimplement kvasprintf
 via a fixed size buffer
Message-ID: <20120104151249.GF3322@phenom.dumpdata.com>
References: <1325677158.25206.244.camel@zakaz.uk.xensource.com>
 <1325677192-10459-2-git-send-email-ian.campbell@citrix.com>
 <4F044D10020000780006A5B4@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F044D10020000780006A5B4@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F046CD5.0053,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 11:58:56AM +0000, Jan Beulich wrote:
> >>> On 04.01.12 at 12:39, Ian Campbell <ian.campbell@citrix.com> wrote:
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Acked-by: Jan Beulich <jbeulich@suse.com>

OK, took:

Ian Campbell (3):
      xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX.
      xenbus: maximum buffer size is XENSTORE_PAYLOAD_MAX
      xen/xenbus: don't reimplement kvasprintf via a fixed size buffer

And put the ' xen/xenbus: Reject replies with payload > XENSTORE_PAYLOAD_MAX'
on the stable@kernel.org as well.

Thanks!
