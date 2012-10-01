Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2JASdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:33:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55603 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2JASdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:33:23 -0400
Message-ID: <5069E1F0.5070902@wwwdotorg.org>
Date: Mon, 01 Oct 2012 12:33:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: dtc: import latest upstream dtc
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org> <5069C042.40209@gmail.com> <5069C11C.6040505@wwwdotorg.org> <5069D946.1060502@gmail.com>
In-Reply-To: <5069D946.1060502@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 11:56 AM, Rob Herring wrote:
> On 10/01/2012 11:13 AM, Stephen Warren wrote:
>> On 10/01/2012 10:09 AM, Rob Herring wrote:
>>> On 09/28/2012 04:25 PM, Stephen Warren wrote:
>>>> From: Stephen Warren <swarren@nvidia.com>
>>>>
>>>> This updates scripts/dtc to commit 317a5d9 "dtc: zero out new label
>>>> objects" from git://git.jdl.com/software/dtc.git.
>>>>
>>>> This adds features such as:
>>>> * /bits/ syntax for cell data.
>>>> * Math expressions within cell data.
>>>> * The ability to delete properties or nodes.
>>>> * Support for #line directives in the input file, which allows the use of
>>>>   cpp on *.dts.
>>>> * -i command-line option (/include/ path)
>>>> * -W/-E command-line options for error/warning control.
>>>> * Removal of spew to STDOUT containing the filename being compiled.
>>>> * Many additions to the libfdt API.
>>>>
>>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>>
>>> Seems dtc doesn't really have a maintainer. Probably makes more sense
>>> for me to take this unless there are objections.
>>
>> Will you also take the two kbuild patches I posted that depend on this
>> (e.g. "kbuild: introduce cmd_dtc_cpp")? I'd assumed that Michal Marek
>> would take this given the dependencies and that he's take a fair number
>> of dtc patches recently.
> 
> No. I think whether we use the cpp preprocessor or not needs more time
> to discuss and some level of agreement. So I don't think it is 3.7 material.

Oh, you were planning on taking the dtc update into 3.7? I had assumed
you meant for 3.8. There wouldn't be any dependencies if you take the
dtc update now, so it'd probably be fine.

What more do you think needs discussion re: dtc+cpp?
