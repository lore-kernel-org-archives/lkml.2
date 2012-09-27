Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2I0EoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:44:21 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44495 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab2I0EoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:44:20 -0400
Message-ID: <1348721055.2509.0.camel@dabdike>
Subject: Re: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2012 08:44:15 +0400
In-Reply-To: <yq13924b4uw.fsf@sermon.lab.mkp.net>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike> <1348470210.2475.47.camel@ThinkPad-T420>
	 <1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 22:02 -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> Plus, I think it fixes a bug where you get different behaviours
> James> from REQ_TYPE_BLOCK_PC commands when a driver is and isn't
> James> attached (I've cc'd Martin to see what he thinks).
> 
> I'm fine with having the eh action be triggered for FS requests only, if
> that's what you're asking?

Sort of ... I was thinking do it for all non REQ_TYPE_BLOCK_PC commands
(which includes flush and other strange types), but if you think it
should only be for REQ_TYPE_FS, that's fine too.

James



