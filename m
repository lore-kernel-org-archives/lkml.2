Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0KWVTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:19:03 -0500
Received: from hull.simtec.co.uk ([78.105.113.97]:40088 "EHLO
	preston.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750991Ab0KWVTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:19:01 -0500
X-Greylist: delayed 2727 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2010 16:19:01 EST
Message-ID: <4CEC2516.3080102@simtec.co.uk>
Date: Tue, 23 Nov 2010 20:33:26 +0000
From: Ben Dooks <ben@simtec.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Vincent Sanders <vince@simtec.co.uk>
Subject: Re: [PATCH 1/2] mfd: Include <linux/io.h> instead of <asm/io.h>
References: <1289375271.28822.3.camel@mola>
In-Reply-To: <1289375271.28822.3.camel@mola>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/10 07:47, Axel Lin wrote:
> As warned by checkpatch.pl, use #include <linux/io.h> instead of <asm/io.h>
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Ben Dooks <ben@simtec.co.uk>
