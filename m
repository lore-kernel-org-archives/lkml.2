Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2I0CC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:02:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51411 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2I0CC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:02:28 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH scsi] Add NULL checking of return value from scsi_cmd_to_driver()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1348464626.2475.13.camel@ThinkPad-T420>
	<1348465493.2467.3.camel@dabdike>
	<1348470210.2475.47.camel@ThinkPad-T420>
	<1348472104.2467.8.camel@dabdike>
Date: Wed, 26 Sep 2012 22:02:15 -0400
In-Reply-To: <1348472104.2467.8.camel@dabdike> (James Bottomley's message of
	"Mon, 24 Sep 2012 11:35:04 +0400")
Message-ID: <yq13924b4uw.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> Plus, I think it fixes a bug where you get different behaviours
James> from REQ_TYPE_BLOCK_PC commands when a driver is and isn't
James> attached (I've cc'd Martin to see what he thinks).

I'm fine with having the eh action be triggered for FS requests only, if
that's what you're asking?

-- 
Martin K. Petersen	Oracle Linux Engineering
