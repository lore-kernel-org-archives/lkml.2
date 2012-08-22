Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab2HVTCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:02:47 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43216 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754646Ab2HVTCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:02:45 -0400
Message-ID: <50352CCF.3030007@xenotime.net>
Date: Wed, 22 Aug 2012 12:02:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Thai Bui <blquythai@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
References: <1344891431-30869-1-git-send-email-blquythai@gmail.com> <20120813212151.GA15429@phenom.dumpdata.com> <CAKkTMC5SP6LgWbhtkU_HCBUAfArGuHXtp4mcwi2tFTjZOwVQbA@mail.gmail.com> <5029823A.9020207@xenotime.net> <20120814011826.GA2255@leaf> <502AB14C.6090406@xenotime.net> <20120814205537.GA2879@jtriplet-mobl1> <502AC233.5020105@xenotime.net> <20120814221429.GA4109@jtriplet-mobl1>
In-Reply-To: <20120814221429.GA4109@jtriplet-mobl1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 03:14 PM, Josh Triplett wrote:

> On Tue, Aug 14, 2012 at 02:25:07PM -0700, Randy Dunlap wrote:
>> Surely.  I have no gross objection to this specific patch.
> 
> OK.  Thanks!
> 
> PATCHv2 will hide the option behind EMBEDDED and make it default to y.
> 
> - Josh Triplett


BTW, I think that it would be Good if you would Cc: the
author(s) of initcall_debug (Ingo, Arjan ?).

thanks,
-- 
~Randy
