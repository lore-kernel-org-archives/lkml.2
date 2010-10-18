Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab0JRFCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:02:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:49672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0JRFCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:02:49 -0400
Message-ID: <4CBBD4F6.2080506@kernel.org>
Date: Mon, 18 Oct 2010 07:02:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7 2/2] shpchp: update workqueue usage
References: <4CB86966.5020606@kernel.org>	<4CB8698A.8030202@kernel.org> <20101017200347.5ca09aed@jbarnes-desktop>
In-Reply-To: <20101017200347.5ca09aed@jbarnes-desktop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 05:02:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/18/2010 05:03 AM, Jesse Barnes wrote:
> ...and dropped again.  Hadn't realized they depend on stuff from your
> workqueue tree.  Please just include them there assuming Kenji-san
> doesn't nack them.
> 
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Ah, sorry about that.  I for some reason thought alloc_ordered_queue()
was already mainline.  I'll route this through the wq tree.

Thank you.

-- 
tejun
