Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2HPNrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:47:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35704 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab2HPNrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:47:33 -0400
Message-ID: <502CF9DA.8030701@parallels.com>
Date: Thu, 16 Aug 2012 17:47:06 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120815092116.700948346@openvz.org> <20120815092409.591460800@openvz.org> <20120815204546.GC25062@fieldses.org> <20120815210237.GF25421@moon> <20120815220622.GA28054@fieldses.org> <20120816062448.GA32081@moon> <20120816123814.GD1209@moon> <20120816134339.GQ23464@ZenIV.linux.org.uk>
In-Reply-To: <20120816134339.GQ23464@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 05:43 PM, Al Viro wrote:
> On Thu, Aug 16, 2012 at 04:38:14PM +0400, Cyrill Gorcunov wrote:
> 
>> Hi Bruce, thinking a bit more I guess using general encode_fh is not that
>> convenient since it operates with dentries while our fdinfo output deals
>> with inodes. Thus I should either provide some new encode_fh variant
>> which would deal with inodes directly without "parents". Which doesn't
>> look for me anyhow better than the new export_encode_inode_fh helper.
> 
> Huh?  You do have dentries, for crying out loud...

Sometimes we don't -- the inotify thing gets an inode only.
Unlike other notifies that have dentries at hands...

> .
> 

Thanks,
Pavel
