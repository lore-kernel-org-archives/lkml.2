Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2F0NOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:14:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47215 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2F0NOK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 27 Jun 2012 09:14:10 -0400
Message-Id: <4FEB236C020000780008C392@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 27 Jun 2012 14:14:52 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>, "Will Auld" <will.auld@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Tony Luck" <tony.luck@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: Re: [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.06.12 at 05:51, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> This is updated xen vMCE design foils, according to comments from community 
> recently.
> 
> This foils focus on vMCE part of Xen MCA, so as Keir said, it's some dense.
> Later Will will present a document to elaborate more, including Intel MCA 
> and surrounding features and Xen implementation.

For MCi_CTL2 you probably meant to say "allow setting CMCI_EN
and error count threshold"?

The 2-bank approach also needs to be brought in line with the
current host derived value in MCG_CAP, especially if the code to
implement this new model doesn't make it into 4.2 (which would
generally save a larger value).

Jan

