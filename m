Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0IJDd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 23:33:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62153 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0IJDdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 23:33:42 -0400
To: Anil kumar <anils_r@yahoo.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: scsi_cmnd data_buffer checksum
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <198194.69355.qm@web32407.mail.mud.yahoo.com>
Date: Thu, 09 Sep 2010 23:33:34 -0400
In-Reply-To: <198194.69355.qm@web32407.mail.mud.yahoo.com> (Anil kumar's
	message of "Thu, 9 Sep 2010 12:34:55 -0700 (PDT)")
Message-ID: <yq1iq2es25t.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Anil" == Anil kumar <anils_r@yahoo.com> writes:

Anil> But I had a quick question, isn't that drive has to support
Anil> "protection enable" also.

Just register DIX Type 0 in the host's protection mask.  That'll enable
protected transfer to the HBA only.


Anil> Also, does Controller FW need to do anything extra to send DIF
Anil> block down to drive. Ideally we will be sending 512 byte blocks
Anil> down to drive.

	http://oss.oracle.com/~mkp/docs/dix-draft.pdf

-- 
Martin K. Petersen	Oracle Linux Engineering
