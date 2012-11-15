Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768013Ab2KOPZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:25:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25087 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423166Ab2KOPZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:25:45 -0500
To: dgilbert@interlog.com
Cc: Christoph Hellwig <hch@infradead.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
	<1352405238-23267-4-git-send-email-nab@linux-iscsi.org>
	<20121115110432.GD28956@infradead.org> <50A5043E.1030301@interlog.com>
Date: Thu, 15 Nov 2012 10:25:32 -0500
In-Reply-To: <50A5043E.1030301@interlog.com> (Douglas Gilbert's message of
	"Thu, 15 Nov 2012 10:03:26 -0500")
Message-ID: <yq1ehju28ib.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> On 12-11-15 06:04 AM, Christoph Hellwig wrote:
>>> + /*
>>> + * Enable WRITE_SAME emulation for IBLOCK, use scsi_debug.c default
>>> + */
>> 
>> Why would we care what scsi_debug.c uses?

Doug> Would you prefer no hint of where the magic number came from? At
Doug> least somebody who cares when they see that comment might contact
Doug> Martin Petersen and ask why he chose that value.

And the answer is that WRITE SAME(10) takes a two-byte block count.

-- 
Martin K. Petersen	Oracle Linux Engineering
