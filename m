Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2JAR4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:56:33 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58892 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2JAR4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:56:32 -0400
Message-ID: <5069D946.1060502@gmail.com>
Date: Mon, 01 Oct 2012 12:56:22 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: dtc: import latest upstream dtc
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org> <5069C042.40209@gmail.com> <5069C11C.6040505@wwwdotorg.org>
In-Reply-To: <5069C11C.6040505@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 11:13 AM, Stephen Warren wrote:
> On 10/01/2012 10:09 AM, Rob Herring wrote:
>> On 09/28/2012 04:25 PM, Stephen Warren wrote:
>>> From: Stephen Warren <swarren@nvidia.com>
>>>
>>> This updates scripts/dtc to commit 317a5d9 "dtc: zero out new label
>>> objects" from git://git.jdl.com/software/dtc.git.
>>>
>>> This adds features such as:
>>> * /bits/ syntax for cell data.
>>> * Math expressions within cell data.
>>> * The ability to delete properties or nodes.
>>> * Support for #line directives in the input file, which allows the use of
>>>   cpp on *.dts.
>>> * -i command-line option (/include/ path)
>>> * -W/-E command-line options for error/warning control.
>>> * Removal of spew to STDOUT containing the filename being compiled.
>>> * Many additions to the libfdt API.
>>>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> Seems dtc doesn't really have a maintainer. Probably makes more sense
>> for me to take this unless there are objections.
> 
> Will you also take the two kbuild patches I posted that depend on this
> (e.g. "kbuild: introduce cmd_dtc_cpp")? I'd assumed that Michal Marek
> would take this given the dependencies and that he's take a fair number
> of dtc patches recently.

No. I think whether we use the cpp preprocessor or not needs more time
to discuss and some level of agreement. So I don't think it is 3.7 material.

Rob

