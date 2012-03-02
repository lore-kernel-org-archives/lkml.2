Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab2CBP3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:29:38 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:46668 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab2CBP3g convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Fri, 2 Mar 2012 10:29:36 -0500
Message-Id: <4F50F594020000780007612D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Mar 2012 15:30:12 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: <jeremy@goop.org>, "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, <tglx@linutronix.de>,
        "Andi Kleen" <ak@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC patch] cmpxchg_double: remove local variables to get
 better performance
References: <1330677063.21053.1532.camel@debian>
 <4F5098B80200007800075F33@nat28.tlf.novell.com>
 <1330678843.21053.1553.camel@debian>
 <4F509CE30200007800075F84@nat28.tlf.novell.com>
 <4F50E376.3030000@intel.com>
In-Reply-To: <4F50E376.3030000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.03.12 at 16:12, Alex Shi <alex.shi@intel.com> wrote:
> On 03/02/2012 05:11 PM, Jan Beulich wrote:
>> In particular, requiring an L suffix here on literals should be avoided.
> 
> 
> Even the each macro may save 0x40 bytes text, and bring more 10%
> execution speed?

Again - if you see meaningful text size differences with optimization
properly enabled, this may need investigation at the compiler end.

Jan

