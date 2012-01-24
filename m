Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2AXATh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:19:37 -0500
Received: from natasha.panasas.com ([67.152.220.90]:56047 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2AXATf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:19:35 -0500
Message-ID: <4F1DF90C.5070108@panasas.com>
Date: Tue, 24 Jan 2012 02:19:24 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Masatake YAMATO <yamato@redhat.com>, <kzak@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <util-linux@vger.kernel.org>
Subject: Re: /etc/fstab.d yes or not
References: <20120120140444.GC13157@x2.net.home> <20120120.232002.849876084731555262.yamato@redhat.com> <CAPXgP10uUpSQzX0RzYY24uDBkNkRXM7NbR0H6P=dZ=+LxdX3Fw@mail.gmail.com>
In-Reply-To: <CAPXgP10uUpSQzX0RzYY24uDBkNkRXM7NbR0H6P=dZ=+LxdX3Fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 04:56 PM, Kay Sievers wrote:
> 
> It's an old glibc API, and /etc/fstab is ABI, not a service config
> file, which now can read more than one file. It's a very different
> problem. It an ABI change, not a config extension.
> 

Can't we have our cake and eat it too?

I mean why not have both?

The subsystem that you currently plan to parse the /etc/fstab.d/ will
intelligently  add the /etc/fstab.d/ entries to /etc/fstab before
actually processing and mounting /etc/fstab.

So the rpm guys have their /etc/fstab.d/ convenience and the rest
of the  ABI is kept intact. (If you can't bit them join them)

Since /etc/fstab is hand edited as well. There are lots of smart
things that can be done like a remark (#) marker at the end of the
file that all /etc/fstab.d/ entries get to be added after. (And
a comment for the user) and some smart duplicate removal of, and
so on ... Even a marker per line added.

Just my $0,017
Boaz
