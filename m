Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2BHPlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:41:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab2BHPln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:41:43 -0500
Date: Wed, 8 Feb 2012 16:34:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 4/6] staging: android/lowmemorykiller: Better mm
	handling
Message-ID: <20120208153447.GC15782@redhat.com>
References: <20120203163056.GA4190@redhat.com> <20120206162947.GD5117@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206162947.GD5117@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Anton Vorontsov wrote:
>
> LMK should not directly check for task->mm. The reason is that the
> process' threads may exit or detach its mm via use_mm(), but other
> threads may still have a valid mm. To catch this we use
> find_lock_task_mm(), which walks up all threads and returns an
> appropriate task (with lock held).

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

