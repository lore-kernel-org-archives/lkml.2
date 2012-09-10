Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2IJRBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:01:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35067 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2IJRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:01:07 -0400
Message-ID: <504E1CD0.8040306@gmail.com>
Date: Mon, 10 Sep 2012 11:01:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 0/3] perf: precise mode and exclude_guest
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com> <1347296241.2124.32.camel@twins>
In-Reply-To: <1347296241.2124.32.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/12 10:57 AM, Peter Zijlstra wrote:
> On Mon, 2012-09-10 at 10:40 -0600, David Ahern wrote:
>> Hopefully thi wraps up the precise mode-exclude_guest dependency.
>> I'm sure someone will let me know if I screwed up the attribution
>> in the second patch.
>
>
> I'll wait with applying until we have the IBS stuff sorted, other than
> that, thanks for collecting this..
>

Robert recently confirmed that this series should not have an impact on 
AMD as it currently stands -- exclude attributes are ignored. And then 
his patch to require they be unset works fine with the first patch in 
this set because of the existing EINVAL fallback handling in perf-record 
and perf-top.

Did you have something else in mind that needs to be done?

David
