Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2I0PGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:06:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2I0PGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:06:31 -0400
Message-ID: <50646B70.5010100@suse.cz>
Date: Thu, 27 Sep 2012 17:06:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Kbuild: use normal compression settings for tar*-pkg
References: <1347133679-14641-1-git-send-email-andi@firstfloor.org> <20120911004633.GA21147@localhost>
In-Reply-To: <20120911004633.GA21147@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.9.2012 02:46, Fengguang Wu wrote:
> On Sat, Sep 08, 2012 at 12:47:59PM -0700, Andi Kleen wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> For large kernel configurations (like a distribution kernel)
>> targz-pkg takes a quite long time to just do the compression.
>> I clocked it at 15+mins for a SUSE kernel like config on a fast
>> system.  And tarxz and bzip2 are even slower.
>>
>> The main reason is that the script that is doing the taring sets
>> the highest compression level (-9).  When I change it to just
>> use the defaults the gzip time for the same kernel goes down
>> to ~3 mins. I haven't tested xz and bzip, but I expect those
>> to be much faster too.
>>
>> I'm not willing to wait that long for a small compression
>> gain. So just change the script to use the defaults.
> 
> Makes sense to me.
> 
> Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Applied to kbuild.git#kbuild.

Michal

