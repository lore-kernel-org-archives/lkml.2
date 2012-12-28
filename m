Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2L1AmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:42:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44154 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2L1AmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:42:14 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50DCEAC8.7000600@jp.fujitsu.com>
Date: Fri, 28 Dec 2012 09:41:44 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        sage@newdream.net, dchinner@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, gthelen@google.com, fengguang.wu@intel.com,
        glommer@parallels.com, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 3/8] use vfs __set_page_dirty interface instead of
 doing it inside filesystem
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456261-14579-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1356456261-14579-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/26 2:24), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Following we will treat SetPageDirty and dirty page accounting as an integrated
> operation. Filesystems had better use vfs interface directly to avoid those details.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> Acked-by: Sage Weil <sage@inktank.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


