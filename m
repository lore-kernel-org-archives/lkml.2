Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0FHRlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:41:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab0FHRls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:41:48 -0400
Date: Tue, 8 Jun 2010 10:41:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V4
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
Message-ID: <alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Dave Chinner wrote:
>
> Can you please consider this patch series for 2.6.35?

Yeah, no. See the several lkml discussions and the -rc2 announcement about 
how I do _not_ intend to merge anything even remotely "new code" this time 
around.

So purely regression fixes and serious bugfixes (oopses/security issues).

			Kubys
