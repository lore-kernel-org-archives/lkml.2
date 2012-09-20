Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2ITQKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:10:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55905 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2ITQKD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 20 Sep 2012 12:10:03 -0400
Message-Id: <505B5C0C020000780009CC14@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 20 Sep 2012 17:10:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Oliver Chick" <oliver.chick@citrix.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk
 drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
 <20120920134951.GC1998@localhost.localdomain>
 <1348150422.24539.58.camel@oliverchick-Precision-WorkStation-T3400>
In-Reply-To: <1348150422.24539.58.camel@oliverchick-Precision-WorkStation-T3400>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.09.12 at 16:13, Oliver Chick <oliver.chick@citrix.com> wrote:
> 3) Having blkback inform blkfront on startup as to how many grefs it is
> willing to persistently-map. We then hit the same question again though:
> what should be do if blkfront ignores this limit?

Not really - if any information coming from the backend is being
ignored by the frontend, then it certainly can't expect consistent
performance.

Jan

