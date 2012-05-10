Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab2EJNer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:34:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51791 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2EJNeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAMYGaxosaVXmpQQqpq+bGV9F7-i8APTpDq=ErWdhw2EHGEzmKg@mail.gmail.com>
References: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com>
	<4FA2C946.60006@redhat.com>
	<4FA2EA4A.6040703@redhat.com>
	<CAMYGaxosaVXmpQQqpq+bGV9F7-i8APTpDq=ErWdhw2EHGEzmKg@mail.gmail.com>
Date: Thu, 10 May 2012 19:04:45 +0530
Message-ID: <CAMYGaxruZbhvtZg76_zo6-BjChObpCAE8-MTA=xbBOavct+XNw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mlock: split the shmlock_user_lock spinlock into per
 user_struct spinlock
From: rajman mekaco <rajman.mekaco@gmail.com>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any updates on this ?
