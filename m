Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2IXLgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:36:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51703 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2IXLgn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 24 Sep 2012 07:36:43 -0400
Message-Id: <506061E6020000780009D4AB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 24 Sep 2012 12:36:38 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Oliver Chick" <oliver.chick@citrix.com>
Cc: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] Persistent grant maps for xen blk
 drivers
References: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
In-Reply-To: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.09.12 at 17:52, Oliver Chick <oliver.chick@citrix.com> wrote:
> Changes since v1:
> 
>  * Maximum number of persistent grants per device now 64, rather than
>    256, as this is the actual maxmimum request in a (1 page) ring.

As said previously, I don't see why this needs to have a separate
#define at all - it's simply __RING_SIZE(). No adding this would
also imply that - apart from perhaps documenting the new xenstore
nodes - io/blkif.h would need changing at all (which otherwise would
require a hypervisor side patch to be submitted too).

Jan

