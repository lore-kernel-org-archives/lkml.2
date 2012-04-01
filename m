Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2DADUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 23:20:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37265 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab2DADUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 23:20:31 -0400
Message-ID: <4F77C972.2000200@zytor.com>
Date: Sat, 31 Mar 2012 20:20:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend core dump note section to contain file names of
 mapped files
References: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com> <20120401031329.GP17822@one.firstfloor.org>
In-Reply-To: <20120401031329.GP17822@one.firstfloor.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 08:13 PM, Andi Kleen wrote:
>> I propose to save this information in core dump, as a new note
>> in note segment.
> 
> Seems like a good idea but rather than write complicated code i would just reuse
> the /proc/*/maps code and dump it in that format?
> 

Does /proc/*/maps handle oddball characters in filenames?

	-hpa


