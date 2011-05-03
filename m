Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1ECLUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:20:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29304 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1ECLUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:20:35 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] fs: remove FS_COW_FL
In-reply-to: <4DBFC6D0.3010105@cn.fujitsu.com>
References: <4DA7B559.8060800@cn.fujitsu.com> <4DBFC6D0.3010105@cn.fujitsu.com>
Date: Tue, 03 May 2011 07:20:11 -0400
Message-Id: <1304421568-sup-4709@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DBFE4FF.008E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Li Zefan's message of 2011-05-03 05:11:44 -0400:
> Any comments? If this patch is acceptable, it should be queued for .39?
> since fs.h is exported to userspace.
>
> Li Zefan wrote:
> > FS_COW_FL and FS_NOCOW_FL were newly introduced to control per file
> > COW in btrfs, but FS_NOCOW_FL is sufficient.
> > 

Good point, I'll send this in.

-chris
