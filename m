Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381Ab2FHQDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:03:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60228 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab2FHQDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:03:41 -0400
Message-ID: <4FD22228.2030607@zytor.com>
Date: Fri, 08 Jun 2012 09:02:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
References: <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com> <1339065932.23343.18.camel@twins> <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com> <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com> <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop> <20120608135117.GB31359@aftab.osrc.amd.com> <1339163986.2507.19.camel@laptop> <CABPqkBSAO_7W_pN+uq0uy-vaciBEE57oNF9Q6s_o39SBVWbc3Q@mail.gmail.com> <20120608141714.GE31359@aftab.osrc.amd.com>
In-Reply-To: <20120608141714.GE31359@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 07:17 AM, Borislav Petkov wrote:
> On Fri, Jun 08, 2012 at 04:03:38PM +0200, Stephane Eranian wrote:
>> On Fri, Jun 8, 2012 at 3:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Fri, 2012-06-08 at 15:51 +0200, Borislav Petkov wrote:
>>>> Provided, of course, newer microcode versions means a
>>>> higher version number.
>>>
>>> Fair enough, I assumed this.. is this true?
>>>
>> I would think so, otherwise it gets even messier!
> 
> Need to get Intel folk to say something here, hpa?
> 

There are some exceptions; but it's good enough for this purpose.

The main exception is that not every revision may be installable on
every CPU; so you might have 0x20, 0x24, 0x28 on one CPU and 0x22, 0x26,
0x2a on another; this only requires caution when you set your bracket
values.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

