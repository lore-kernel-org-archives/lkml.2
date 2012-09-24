Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2IXLo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:44:58 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:10457 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2IXLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:44:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344211200"; 
   d="scan'208";a="14721671"
Message-ID: <1348487093.3452.62.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2] Persistent grant maps for xen blk drivers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "Oliver Chick (Intern)" <oliver.chick@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Date: Mon, 24 Sep 2012 12:44:53 +0100
In-Reply-To: <506061E6020000780009D4AB@nat28.tlf.novell.com>
References: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
	 <506061E6020000780009D4AB@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 12:36 +0100, Jan Beulich wrote:
> >>> On 21.09.12 at 17:52, Oliver Chick <oliver.chick@citrix.com> wrote:
> > Changes since v1:
> > 
> >  * Maximum number of persistent grants per device now 64, rather than
> >    256, as this is the actual maxmimum request in a (1 page) ring.
> 
> As said previously, I don't see why this needs to have a separate
> #define at all - it's simply __RING_SIZE(). No adding this would
> also imply that - apart from perhaps documenting the new xenstore
> nodes - io/blkif.h would need changing at all (which otherwise would
> require a hypervisor side patch to be submitted too).

Whether or not this definition is required in blkif.h we certainly want
a patch to the hypervisor tree to document this new protocol extension.

Ian.

