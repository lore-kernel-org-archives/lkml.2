Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0LVSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:09:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0LVSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:09:54 -0500
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, dgilbert@interlog.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Penokie\, George" <George.Penokie@lsi.com>
Subject: Re: RFC: short reads on block devices
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4D0B945C.2060309@interlog.com>
	<1292618194.2820.90.camel@mulgrave.site> <4D0F2524.5030407@suse.de>
	<1292860848.3034.6.camel@mulgrave.site>
Date: Wed, 22 Dec 2010 13:08:53 -0500
In-Reply-To: <1292860848.3034.6.camel@mulgrave.site> (James Bottomley's
	message of "Mon, 20 Dec 2010 10:00:48 -0600")
Message-ID: <yq1mxnxznm2.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> Well, T10 always gives the most conservative approach.  All other
James> array (and certainly all disk) vendors seem to confirm valid data
James> up to the error ... certainly for the DIF case, Martin secured
James> this agreement.

Well, secured is probably too strong a word. Nobody objected when it was
put in the DIX spec...

-- 
Martin K. Petersen	Oracle Linux Engineering
