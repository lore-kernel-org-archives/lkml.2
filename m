Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0JBIuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 04:50:11 -0400
Received: from freeflow.nu ([178.79.134.28]:35337 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0JBIuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 04:50:10 -0400
Message-ID: <4CA6F240.5090702@kernel.org>
Date: Sat, 02 Oct 2010 11:50:08 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>, David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slub: Fix signedness warnings
References: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.9.2010 15.02, Namhyung Kim wrote:
> The bit-ops routines require its arg to be a pointer to unsigned long.
> This leads sparse to complain about different signedness as follows:
>
>   mm/slub.c:2425:49: warning: incorrect type in argument 2 (different signedness)
>   mm/slub.c:2425:49:    expected unsigned long volatile *addr
>   mm/slub.c:2425:49:    got long *map
>
> Signed-off-by: Namhyung Kim<namhyung@gmail.com>

The series has been applied. Thanks!
