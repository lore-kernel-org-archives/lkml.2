Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab0ENUHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:07:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48606 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759447Ab0ENUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:07:18 -0400
Date: Fri, 14 May 2010 13:06:33 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 8/10] fs/ocfs2/dlm: Use kstrdup
Message-ID: <20100514200632.GD29764@mail.oracle.com>
Mail-Followup-To: Julia Lawall <julia@diku.dk>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005142130310.28935@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005142130310.28935@ask.diku.dk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BEDAD71.01B9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:30:48PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kstrdup when the goal of an allocation is copy a string into the
> allocated region.

	Seems fine.  I'll send it along.

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
