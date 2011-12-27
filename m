Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1L0Gw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:52:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59415 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab1L0Gwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:52:51 -0500
Message-ID: <4EF96BC9.6020002@cn.fujitsu.com>
Date: Tue, 27 Dec 2011 14:55:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/2] cgroup: mark cgroup_rmdir_waitq and cgroup_attach_proc()
 as static
References: <1324964786-19052-1-git-send-email-kirill@shutemov.name>
In-Reply-To: <1324964786-19052-1-git-send-email-kirill@shutemov.name>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 14:52:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 14:52:04,
	Serialize complete at 2011-12-27 14:52:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
