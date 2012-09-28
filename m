Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2I1HsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:48:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47589 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942Ab2I1HsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:48:22 -0400
Message-ID: <1348818498.2411.8.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 08:48:18 +0100
In-Reply-To: <yq1bogr8itb.fsf@sermon.lab.mkp.net>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike> <1348470210.2475.47.camel@ThinkPad-T420>
	 <1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	 <1348721055.2509.0.camel@dabdike> <yq1bogr8itb.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 13:41 -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> >> I'm fine with having the eh action be triggered for FS requests only,
> >> if that's what you're asking?
> 
> James> Sort of ... I was thinking do it for all non REQ_TYPE_BLOCK_PC
> James> commands (which includes flush and other strange types), but if
> James> you think it should only be for REQ_TYPE_FS, that's fine too.
> 
> I'm ok either way.

OK, let's mirror the code in scsi.c then, so != REQ_TYPE_BLOCK_PC.

James


