Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1DRNJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:09:05 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:53892 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1DRNI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:08:58 -0400
Message-ID: <4DAC37E7.5010809@tilera.com>
Date: Mon, 18 Apr 2011 09:08:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/3] tile: replace mm->cpu_vm_mask with mm_cpumask()
References: <20110418211455.9359.A69D9226@jp.fujitsu.com> <20110418211914.9361.A69D9226@jp.fujitsu.com>
In-Reply-To: <20110418211914.9361.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/2011 8:18 AM, KOSAKI Motohiro wrote:
> We plan to change mm->cpu_vm_mask definition later. Thus, this patch convert
> it into proper macro.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>

Thanks; I wasn't aware of this macro.  I'll take this change into my tree
unless you would like to push it.

> Chris, I couldn't get cross compiler for tile. thus I hope you check it carefully.

The toolchain support is currently only available from Tilera (at
http://www.tilera.com/scm/) but we are in the process of cleaning it up to
push it up to the community.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

