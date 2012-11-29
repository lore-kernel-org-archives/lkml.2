Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2K2SrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:47:19 -0500
Received: from ra.se.axis.com ([195.60.68.13]:39878 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab2K2SrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:47:16 -0500
Date: Thu, 29 Nov 2012 19:47:10 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFQ PATCH] cifs: Change default security error message
Message-ID: <20121129184709.GR27196@axis.com>
References: <20121129173053.GQ27196@axis.com>
 <CAH2r5mvKGnZdUNb1-Msb10NBypG2cQm+5JrN-Ajv8VNvmX2+Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvKGnZdUNb1-Msb10NBypG2cQm+5JrN-Ajv8VNvmX2+Pg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:52:03AM -0600, Steve French wrote:
> This has already been changed in the cifs-2.6.git for-next  branch.
> We had run into problems with Apple Server with ntlmv2 so it took
> longer than expected to test it, and it was too late for 3.7 so the
> patch to move to ntlmssp encapsulated ntlmv2 which removes this
> warning is in cifs-2.6.git and queued for 3.8

Oh excellent. What´s the git url for the cifs-tree?
The one referred to in MAINTAINERS doesn´t seem to work.

T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git

Or possibly I´m missing something. :-)

Thanks,

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
