Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0KJM2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:28:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47048 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab0KJM2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:28:18 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20101109221338.GA19947@suse.de>
References: <1289339119.2191.92.camel@laptop>
	 <20101109221338.GA19947@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 13:27:17 +0100
Message-ID: <1289392037.2191.105.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 14:13 -0800, Greg KH wrote:

> You missed the embedded track at Plumbers where we talked about never
> adding another class to the kernel.  Please use bus_id instead for this.

I did, it was early and I wasn't aware this all comes under the heading
of embedded.

Anyway, anybody got a good example of bus_type I can 'borrow' ?

Also, it would be really nice if you (plural) could make this subsystem
thing happen, calling tihngs a bus that aren't a bus just makes me
upset ;-)
