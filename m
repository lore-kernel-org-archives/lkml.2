Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab0JRUjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:39:35 -0400
Received: from mail80c7.megamailservers.com ([69.49.98.180]:51062 "EHLO
	mail80c7.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756071Ab0JRUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:39:33 -0400
X-Greylist: delayed 1984 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 16:39:33 EDT
X-Authenticated-User: paulkf.microgate.com
Message-ID: <4CBCB7BA.5080601@microgate.com>
Date: Mon, 18 Oct 2010 15:10:18 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] char: synclink_gt: fix information leak to userland
References: <1287326496-8178-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1287326496-8178-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=Rh3jrC7cCk45g8Q2OvB8BL1DmyOUGk8APGuZ8sVT15E= c=1 sm=1
		a=o-tqvJvPIRUA:10 a=IkcTkHD0fZMA:10 a=IzlbXlj4Xhqf7W9accngow==:17
		a=ijWuk3ZyAAAA:8 a=pGLkceISAAAA:8 a=0fOZRVO8yji8SAe3r2IA:9
		a=Vt4wwhwmeILJhamx5PzZzB4Ez68A:4 a=QEXdDO2ut3YA:10 a=vr08yV7lTEoA:10
		a=M2bT9TDNGrIA:10 a=aUOK4Wo89ZcA:10 a=UEqaQSiRgn0A:10 a=oBK5D_4X9z4A:10
		a=NGcOuUOJdRAA:10 a=xBexlFGNibAA:10 a=fEugV1Gw4pQA:10 a=MSl-tDqOz04A:10
		a=IzlbXlj4Xhqf7W9accngow==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Paul Fulghum <paulkf@microgate.com>

On 10/17/2010 8:41 AM, Vasiliy Kulikov wrote:
> Structures tmp_params and new_line are copied to userland with some padding
> fields unitialized.  It leads to leaking of stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>


-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -6h)
www.microgate.com
