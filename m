Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2EUGA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:00:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61789 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2EUGAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:00:22 -0400
Date: Mon, 21 May 2012 09:00:15 +0300
From: Muli Ben-Yehuda <muli@cs.technion.ac.il>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, discuss@x86-64.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kernel/pci-calgary_64.c simple_strtoul cleanup
Message-ID: <20120521060015.GB19135@tyrion.mulix.org>
References: <1337556268.3126.5.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337556268.3126.5.camel@lorien2>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 05:24:28PM -0600, Shuah Khan wrote:
> Change calgary_parse_options() to call kstrtoul() instead of calling
> obsoleted simple_strtoul().
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>

Acked-by: Muli Ben-Yehuda <muli@cs.technion.ac.il>

Cheers,
Muli
