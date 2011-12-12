Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1LLDoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:44:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36467 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab1LLDn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:43:57 -0500
Message-ID: <4EE57879.6060109@gmail.com>
Date: Sun, 11 Dec 2011 19:43:53 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the trivial tree with the wireless-next
 tree
References: <20111205133757.2b6cd1675543c7da26f663a5@canb.auug.org.au> <alpine.LNX.2.00.1112120033380.21970@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1112120033380.21970@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 03:33 PM, Jiri Kosina wrote:
> On Mon, 5 Dec 2011, Stephen Rothwell wrote:
>
>> Hi Jiri,
>>
>> Today's linux-next merge of the trivial tree got a conflict in
>> net/mac80211/work.c between commit e76aadc57228 ("mac80211: revert
>> on-channel work optimisations") from the wireless-next tree and commit
>> 42b2aa86c667 ("treewide: Fix typos in various parts of the kernel, and
>> fix some comments") from the trivial tree.
>>
>> The former removed the comment that was fixed in the latter, so I did
>> that.
>
> I have now dropped the conflicting hunk, thanks for reporting, Stephen.
>

not sure what hunk was removed from this, but if its from my commit I 
can pull -next and redu the patch so that its not conflicting and resend 
if you would like.

Justin P. Mattock
