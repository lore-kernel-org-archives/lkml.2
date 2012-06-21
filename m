Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab2FUQGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:06:16 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57560 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2FUQGP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 21 Jun 2012 12:06:15 -0400
Message-Id: <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 21 Jun 2012 17:06:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Tony Luck" <tony.luck@intel.com>, "Will Auld" <will.auld@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: Re: [vMCE design RFC] Xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.06.12 at 18:13, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> Recently we design xen vMCE as attached.
> Please kindly help me to review it, any comments/suggestions are 
> appreciated.

The concept looks quite okay, provided no OS has a problem with
the limitations imposed (most notably the restriction to a single
reporting bank, particularly in the context of e.g. Linux partly
ignoring the first bank under some conditions iirc).

As to not needing any migration specific adjustments - what if
a migration is in progress when an event needs to be delivered?

Jan

