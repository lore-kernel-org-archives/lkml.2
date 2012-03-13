Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2CMRKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:10:37 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:58166 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757562Ab2CMRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:10:35 -0400
Message-ID: <4F5F7F8C.6030300@xenotime.net>
Date: Tue, 13 Mar 2012 10:10:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com
Subject: Re: linux-next: Tree for Mar 13 (dlm / gfs2)
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
In-Reply-To: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 02:41 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120309:



on i386:

ERROR: "sctp_do_peeloff" [fs/dlm/dlm.ko] undefined!


GFS2_FS selects DLM (if GFS2_FS_LOCKING_DLM, which is enabled).
GFS2_FS selects IP_SCTP if DLM_SCTP, which is not enabled and not
used anywhere else in the kernel tree AFAICT.
DLM just always selects IP_SCTP.


---

~Randy

