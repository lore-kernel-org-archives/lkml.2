Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab2CTVNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:13:46 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:40666 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755067Ab2CTVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:13:44 -0400
Message-ID: <4F68F2FB.60401@xenotime.net>
Date: Tue, 20 Mar 2012 14:13:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.3
References: <1332277125-10785-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1332277125-10785-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 01:58 PM, Geert Uytterhoeven wrote:

> Below is the list of build error/warning regressions/improvements in
> v3.3[1] compared to v3.2[2].
> 
> Summarized:
>   - build errors: +956/-112
>   - build warnings: +3135/-617
> 
> JFYI, when comparing v3.3 to v3.3-rc7[3], the summaries are:
>   - build errors: +927/-91
>   - build warnings: +2464/-505


Hi Geert,

This is with the newly built tools, right?

Where is the WARNINGS section?

242 of the 956 errors are gpio-related.  :(



> Note that there may be false regressions:
>   - The number of configs increased from 106 to 116,
>   - The new toolchains emit a lot more warnings,
>   - The new toolchains add information about which warning option
>     triggered a warning. I postprocessed the logs to remove these
>     annotations, but there may still be slight differences left.
> As a consequence, I only kept the build error regressions in the report
> below. 412 KiB was just too much for lkml.
> Let's hope everything becomes more usable again with v3.4-rc1.
> 
> As master.kernel.org is down, there's no verbose summary yet at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.3.summary.gz
> 
> Happy fixing! ;-)
> 
> Thanks to the linux-next team for providing the build service.
> 
> [1] http://kisskb.ellerman.id.au/kisskb/head/4840.processed/ (all 116 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/4572/ (107 out of 116 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/4812/ (106 out of 116 configs)


-- 
~Randy
