Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030623Ab2CUG5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:57:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53035 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965220Ab2CUG5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:57:47 -0400
Message-ID: <4F697BD9.2040202@zytor.com>
Date: Tue, 20 Mar 2012 23:57:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 06/16] mm/x86: use vm_flags_t for vma flags
References: <20120321065140.13852.52315.stgit@zurg> <20120321065637.13852.58447.stgit@zurg>
In-Reply-To: <20120321065637.13852.58447.stgit@zurg>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 11:56 PM, Konstantin Khlebnikov wrote:
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org

Please put in a patch description.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

