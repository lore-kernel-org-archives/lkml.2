Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2BCAHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:07:47 -0500
Received: from plane.gmane.org ([80.91.229.3]:40028 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab2BCAHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:07:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mantas <grawity@gmail.com>
Subject: Re: could modify sillyrename to put files in /tmp
Date: Fri, 03 Feb 2012 02:07:25 +0200
Message-ID: <jgf8ft$rg5$1@dough.gmane.org>
References: <201202021018234324363@300.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
In-Reply-To: <201202021018234324363@300.cn>
Cc: linux-nfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-02 04:18, wangjing wrote:
> In nfs v3 ,if mulity process visit nfs mount nfs dir ,there sometimes occour .nfsXXX can't delete .
> 
> If modify sillyrename to put files in /tmp ,it will be more friendly to nfs user.

What would then happen if /tmp was on a separate filesystem than the
original file?

> the background
>    1、Linux fs has   /nfsmnt/work_pub/web and /nfsmnt/work_inwork/web ，they use NFS V3 mount
>    2、there is many process will read and write files in the dir /nfsmnt/work_pub/web 
>    3、cron will del  all files in dir  /nfsmnt/work_pub/web in period，and will copy all the files which in the dir /nfsmnt/work_inwork/web 
> 
> in some times delete all files in  /nfsmnt/work_pub/web will faild ,because there is some .nfsXXXX

Then modify the cron job to ignore ".nfs*" files.

-- 
Mantas M.

