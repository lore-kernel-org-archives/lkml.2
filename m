Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767941Ab2KONvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:51:37 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:2824 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767793Ab2KONvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:51:35 -0500
Message-ID: <50A4F326.2000405@parallels.com>
Date: Thu, 15 Nov 2012 17:50:30 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, oleg@redhat.com, rientjes@google.com,
        tvrtko.ursulin@onelan.co.uk, Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 6/7] fs, exportfs: Add exportfs_encode_inode_fh helper
References: <20121114151937.344922058@openvz.org> <20121114152239.840001980@openvz.org> <20121114173757.GJ23604@fieldses.org>
In-Reply-To: <20121114173757.GJ23604@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 09:37 PM, J. Bruce Fields wrote:
> On Wed, Nov 14, 2012 at 07:19:43PM +0400, Cyrill Gorcunov wrote:
>> We will need this helper in the next patch to
>> provide a file handle for inotify marks in
>> /proc/pid/fdinfo output.
>>
>> The patch is rather providing the way to use inodes
>> directly when dentry is not available (like in case
>> of inotify system).
> 
> Looks OK to me.--b.

Thank you, Bruce!

>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> CC: Pavel Emelyanov <xemul@parallels.com>
>> CC: Oleg Nesterov <oleg@redhat.com>
>> CC: Andrey Vagin <avagin@openvz.org>
>> CC: Al Viro <viro@ZenIV.linux.org.uk>
>> CC: Alexey Dobriyan <adobriyan@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: James Bottomley <jbottomley@parallels.com>
>> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> CC: Alexey Dobriyan <adobriyan@gmail.com>
>> CC: Matthew Helsley <matt.helsley@gmail.com>
>> CC: "J. Bruce Fields" <bfields@fieldses.org>
>> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
