Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2B0IOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:14:46 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:25055 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2B0IOo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:2>);
	Mon, 27 Feb 2012 03:14:44 -0500
Message-Id: <4F4B497B0200007800074DE1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 27 Feb 2012 08:14:35 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <ke.yu@intel.com>, <kevin.tian@intel.com>, <lenb@kernel.org>,
        <xen-devel@lists.xensource.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xen/enlighten: Expose MWAIT and MWAIT_LEAF if
 hypervisor OKs it.
References: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
 <1330036270-20015-3-git-send-email-konrad.wilk@oracle.com>
 <4F4775410200007800074992@nat28.tlf.novell.com>
 <20120224235228.GA26913@phenom.dumpdata.com>
In-Reply-To: <20120224235228.GA26913@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.02.12 at 00:52, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > +DEFINE_GUEST_HANDLE(uint32_t);
>> 
>> Do you really need to introduce (step by step) handles for all those
>> uintNN_t types in a way different from Xen's
>> (__DEFINE_XEN_GUEST_HANDLE(uint32, uint32_t))?
> 
> Oh, no. Good eye - I will change it be uint32.

Might be worth converting the recently added counterpart of uint64_t
then too.

Jan

