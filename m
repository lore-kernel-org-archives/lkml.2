Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2HIBxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 21:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2HIBxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 21:53:32 -0400
Date: Thu, 9 Aug 2012 02:53:21 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Wesley Miaw <wmiaw@netflix.com>
Cc: Milan Broz <mbroz@redhat.com>, "msb@google.com" <msb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will =?utf-8?B?RHJld3J54oSi?= <w@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dm: verity support data device
	offset (Linux 3.4.7)
Message-ID: <20120809015321.GC23758@agk-dp.fab.redhat.com>
Mail-Followup-To: Wesley Miaw <wmiaw@netflix.com>,
	Milan Broz <mbroz@redhat.com>, "msb@google.com" <msb@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Will =?utf-8?B?RHJld3J54oSi?= <w@google.com>,
	device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com> <5022CC99.30103@redhat.com> <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com> <5022D29B.9000402@redhat.com> <C8AA8C7B-505E-49E8-AE47-C24843E74543@netflix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8AA8C7B-505E-49E8-AE47-C24843E74543@netflix.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 12:40:23AM +0000, Wesley Miaw wrote:
> This isn't as polished because I pretty much just added support to do what I
> needed. I'm not sure if the LKML is the right place to post, so let me know if
> I should send this somewhere else.
 
cryptsetup patches are best sent to the mailing list mentioned at the bottom of
the project page http://code.google.com/p/cryptsetup/ viz. dm-crypt@saout.de.

Alasdair

