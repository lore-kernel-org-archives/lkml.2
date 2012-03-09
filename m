Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2CISBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:01:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46494 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2CISBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:01:06 -0500
MIME-Version: 1.0
In-Reply-To: <4F5A44E5.6090300@cavium.com>
References: <1330543264-18103-1-git-send-email-ddaney.cavm@gmail.com>
 <1330543264-18103-3-git-send-email-ddaney.cavm@gmail.com> <20120309013324.64DF53E0901@localhost>
 <4F5A44E5.6090300@cavium.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Mar 2012 11:00:44 -0700
X-Google-Sender-Auth: jg2eqENf0lkFyUH8GIpARVebLUg
Message-ID: <CACxGe6v3wnRdyaWeuBZ1RMQf8KD3dV2btQKrrmPAUgQtym_e_g@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] of: Make of_find_node_by_path() traverse /aliases
 for relative paths.
To: David Daney <david.daney@cavium.com>
Cc: David Daney <ddaney.cavm@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 10:59 AM, David Daney <david.daney@cavium.com> wrote:
> On 03/08/2012 05:33 PM, Grant Likely wrote:
>>
>> On Wed, 29 Feb 2012 11:21:04 -0800, David Daney<ddaney.cavm@gmail.com>
>>  wrote:
>>>
>>> From: David Daney<david.daney@cavium.com>
>>>
>>> Currently all paths passed to of_find_node_by_path() must begin with a
>>> '/', indicating a full path to the desired node.
>>>
>>> Augment the look-up code so that if a path does *not* begin with '/',
>>> the path is used as the name of an /aliases property.  The value of
>>> this alias is then used as the full node path to be found.
>>>
>>> Signed-off-by: David Daney<david.daney@cavium.com>
>
> [...]
>
>>
>> All the aliases are already decoded at boot time now.  See
>> of_alias_scan().  Instead of open-coding this, you can add an
>> of_alias_lookup() function something like this (untested):
>>
>
> After objections from davem, and a bit of thought, I already indicated on a
> different branch of this thread that we should drop this patch.
>
> I have improved my code so that it is no longer needed.

Okay.
