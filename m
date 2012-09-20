Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2ITJLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:11:35 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44921 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2ITJLe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 20 Sep 2012 05:11:34 -0400
Message-Id: <505AF9F6020000780009C909@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 20 Sep 2012 10:11:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Oliver Chick" <oliver.chick@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk
 drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <5059D0C8020000780009C4CF@nat28.tlf.novell.com>
 <1348131088.24539.2.camel@oliverchick-Precision-WorkStation-T3400>
In-Reply-To: <1348131088.24539.2.camel@oliverchick-Precision-WorkStation-T3400>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.09.12 at 10:51, Oliver Chick <oliver.chick@citrix.com> wrote:
> Ah yes, you're right - rings can accomodate 64 requests. ijc, and myself
> got muddled. It also explains the comment in my summary that we only use
> the first 60-ish persistent grants!
> 
> With multipage rings, this will probably become a function, rather than
> a constant. Does that sound sensible?

Yes, that's what I was expecting. Whether a separate function/
macro is necessary is unclear, as it's simply __RING_SIZE().

Jan

