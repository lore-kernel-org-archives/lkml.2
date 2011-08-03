Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1HCNDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:03:30 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:48963 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab1HCNDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:03:23 -0400
X-ASG-Debug-ID: 1312376601-03d6a510a8235cb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E394718.4070901@fusionio.com>
Date: Wed, 3 Aug 2011 15:03:20 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] block: swim3: fix unterminated of_device_id table
References: <1312372061.2788.1.camel@phoenix>
X-ASG-Orig-Subj: Re: [PATCH] block: swim3: fix unterminated of_device_id table
In-Reply-To: <1312372061.2788.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312376601
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70786
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-03 13:47, Axel Lin wrote:
> of_device_id structures need a NULL terminating entry, add it.

Thanks, added.

-- 
Jens Axboe

