Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2I0Rlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:41:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28076 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2I0Rld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:41:33 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH scsi] Add NULL checking of return value from scsi_cmd_to_driver()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1348464626.2475.13.camel@ThinkPad-T420>
	<1348465493.2467.3.camel@dabdike>
	<1348470210.2475.47.camel@ThinkPad-T420>
	<1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	<1348721055.2509.0.camel@dabdike>
Date: Thu, 27 Sep 2012 13:41:20 -0400
In-Reply-To: <1348721055.2509.0.camel@dabdike> (James Bottomley's message of
	"Thu, 27 Sep 2012 08:44:15 +0400")
Message-ID: <yq1bogr8itb.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> I'm fine with having the eh action be triggered for FS requests only,
>> if that's what you're asking?

James> Sort of ... I was thinking do it for all non REQ_TYPE_BLOCK_PC
James> commands (which includes flush and other strange types), but if
James> you think it should only be for REQ_TYPE_FS, that's fine too.

I'm ok either way.

-- 
Martin K. Petersen	Oracle Linux Engineering
