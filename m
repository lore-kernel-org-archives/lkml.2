Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2KHB6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:58:45 -0500
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:45027 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2KHB6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:58:44 -0500
Message-ID: <509B117A.6070708@genband.com>
Date: Wed, 07 Nov 2012 19:57:14 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jon Mason <jdmason@kudzu.us>
CC: Andy Grover <agrover@redhat.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: Re: scsi target, likely GPL violation
References: <509A915B.30105@redhat.com> <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
In-Reply-To: <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Nov 2012 01:57:16.0101 (UTC) FILETIME=[60B54F50:01CDBD54]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19348.003
X-TM-AS-Result: No--5.647700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 07:02 PM, Jon Mason wrote:
> I'm not a lawyer, nor do I play one on TV, but if
> I understand the GPL correctly, RTS only needs to provide the relevant
> source to their customers upon request.

Not quite.

Assuming the GPL applies, and that they have modified the code, then 
they must either:

1) include the source with the distributed binary

or

2) include with the binary an offer to provide the source to *any* third 
party

Chris
