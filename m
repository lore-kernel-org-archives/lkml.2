Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1DUOAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:00:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65068 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1DUOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uuE8hY+0+EZMhNhkyG8x3j00EW3KLZmyMU9X/i4unxD0hpXvbKWHlzoY0u8WMY62Ft
         Xr9O4S3QkMqmo0hKQka84En/C7YtJIxKD0ESyLx8lYj86wyytXACxsSm3eB6Eh0R/Ngg
         Yp3ekwbREdktMeWMN8e0qhnT6FrjZ+65bMl1Y=
Message-ID: <4DB03872.2020504@openvz.org>
Date: Thu, 21 Apr 2011 18:00:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask
 on overflow
References: <4DAEF821.4050103@openvz.org> <20110421125345.GC31724@redhat.com> <20110421131748.GB1642@elte.hu> <20110421135742.GZ20887@redhat.com>
In-Reply-To: <20110421135742.GZ20887@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 05:57 PM, Don Zickus wrote:
...
> 
> Cyril is that something you can do because I think all of these patches
> revolve around P4 fixes?  Though I don't know what are all the patches.  I
> know I had one and this patch.  Is there another on Cyril?
> 
> Cheers,
> Don

Don, I've two patches for P4 and one yours which is a fast fix for unknown-nmi.
So I could gather all three patches and send them to Ingo. And you'll see them
and review again as well. Deal? :)

-- 
    Cyrill
