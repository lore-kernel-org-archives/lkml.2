Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2HICEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 22:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab2HICE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 22:04:28 -0400
Date: Thu, 9 Aug 2012 03:04:19 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Wesley Miaw <wmiaw@netflix.com>
Cc: Milan Broz <mbroz@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will =?utf-8?B?RHJld3J54oSi?= <w@google.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dm: verity support data device
	offset (Linux 3.4.7)
Message-ID: <20120809020419.GD23758@agk-dp.fab.redhat.com>
Mail-Followup-To: Wesley Miaw <wmiaw@netflix.com>,
	Milan Broz <mbroz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Will =?utf-8?B?RHJld3J54oSi?= <w@google.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com> <5022CC99.30103@redhat.com> <0066B4B7-B0FA-4C7F-99C4-0AABB577382C@netflix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0066B4B7-B0FA-4C7F-99C4-0AABB577382C@netflix.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 12:40:22AM +0000, Wesley Miaw wrote:
> Apologies if the version increment is incorrect; I was not sure if the minor
> or patch number should be incremented. I assume the different version number is
> what would be used to detect if the data offset option is supported. Thanks.

Minor number is the correct thing to increment as you're retaining
compatibility.  (Your original version would have needed to increment the major
number to indicate incompatibility with existing userspace code.)
 
However, first you need to address the second part of Mikulas's email,
namely to make the case for these changes rather than making no kernel
changes and instead stacking the verity target over a linear target.

To put this another way, your patch offers an alternative way to do
something we think the existing kernel can already do, so you need to
advance some reasons why you believe the new alternative method is worth
adding to the kernel and explain this in the patch header.

Alasdair

