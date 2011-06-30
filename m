Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1F3Sd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:33:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33426 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab1F3Sdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:33:55 -0400
Message-ID: <4E0CBFF0.2040205@zytor.com>
Date: Thu, 30 Jun 2011 11:26:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: {PATCH] fix __packed in exported kernel headers
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz> <20110624135100.GB1708@x4.trippels.de> <201106241833.15424.arnd@arndb.de> <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com>
In-Reply-To: <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 10:00 AM, Mike Frysinger wrote:
>>
>> We generally try to add no such requirements on user applications.
> 
> the only real solution there is to export the compiler.h headers too
> 
> plus, many compilers nowadays (like icc/llvm) tend to include support
> for common gcc attributes ...

Either that OR define a set of macros as being expected by the
environment of the kernel ABI headers (to be provided by the library.)

	-hpa
