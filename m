Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab0DHL4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 07:56:53 -0400
Received: from daytona.panasas.com ([67.152.220.89]:26485 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754340Ab0DHL4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:56:49 -0400
Message-ID: <4BBDC47E.1060405@panasas.com>
Date: Thu, 08 Apr 2010 14:56:46 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Bug #15718] File corruption regression on NFS related to commit
 1f36f774
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.ApF.zsPvLB@chimera>
In-Reply-To: <JVS2s9dmTsP.A.ApF.zsPvLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2010 11:56:48.0355 (UTC) FILETIME=[9179EB30:01CAD712]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 12:13 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15718
> Subject		: File corruption regression on NFS related to commit 1f36f774
> Submitter	: Boaz Harrosh <bharrosh@panasas.com>
> Date		: 2010-03-24 15:49 (15 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/1f36f774b22a0ceb7dd33eca626746c81a97b6a5
> Message-ID	: <4BAA3493.1030802@panasas.com>
> References	: http://marc.info/?l=linux-kernel&m=126944579810350&w=4
> Handled-By	: Al Viro <viro@zeniv.linux.org.uk>
> 
> 

Fix already in main line: 3e297b613491f0d4928aa652a2cd266aa06dc409
	Author: Al Viro <viro@zeniv.linux.org.uk>
	Restore LOOKUP_DIRECTORY hint handling in final lookup on open()

Boaz
