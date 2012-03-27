Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2C0RRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:17:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40708 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab2C0RRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:17:53 -0400
Message-ID: <4F71F634.1050503@zytor.com>
Date: Tue, 27 Mar 2012 10:17:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Michal Nazarewicz <mpn@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <201203262051.24271.vda.linux@googlemail.com> <20120326125129.78975baf.akpm@linux-foundation.org> <CAK1hOcNZ1QdsT2Gajv1y-yAfF85hOTH=18vqqH4itURLtgYfdQ@mail.gmail.com> <20120326131304.018a5f4b.akpm@linux-foundation.org> <4F70CFA4.5020503@zytor.com> <op.wbt93pu4pw9a85@mpn-glaptop>
In-Reply-To: <op.wbt93pu4pw9a85@mpn-glaptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 10:12 AM, Michal Nazarewicz wrote:
> 
> Maybe a regular “if” instead of macro would suffice here?  Compiler should
> be smart enough to optimise out the dead path.
> 

Yes, a regular if would work, but it's also pointless.

	-hpa
