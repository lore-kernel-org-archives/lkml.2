Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2GYTzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:55:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2GYTzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:55:39 -0400
Date: Wed, 25 Jul 2012 12:55:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: zhenzhong.duan@oracle.com
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org,
        Feng Jin <joe.jin@oracle.com>
Subject: Re: [PATCH 2/2] Fetch dmi version from SMBIOS if it exist
Message-Id: <20120725125518.d89b78a6.akpm@linux-foundation.org>
In-Reply-To: <500FD2E5.3010307@oracle.com>
References: <500FD2E5.3010307@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012 19:05:09 +0800
"zhenzhong.duan" <zhenzhong.duan@oracle.com> wrote:

> The right dmi version is in SMBIOS if it's zero in DMI region
> 

This description is too brief to permit me to understand the patch. 
Can you please provide a more detailed explanation?

