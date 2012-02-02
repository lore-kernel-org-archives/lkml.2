Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2BBAf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:35:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2BBAf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:35:27 -0500
MIME-Version: 1.0
In-Reply-To: <20120202003359.9930.9844.stgit@srivatsabhat.in.ibm.com>
References: <20120202003359.9930.9844.stgit@srivatsabhat.in.ibm.com>
Date: Wed, 1 Feb 2012 16:35:25 -0800
X-Google-Sender-Auth: pVbviOtTls1-Vt-fDI9dW9Hu1wE
Message-ID: <CAOS58YMP=iCXk2KFOxXAJFbfKAs0-W5YjjfrD9epDyo9vn4XKw@mail.gmail.com>
Subject: Re: [PATCH] PM/Hibernate: Thaw kernel threads in hibernation_snapshot()
 in error/test path
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 4:34 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> In the hibernation call path, the kernel threads are frozen inside
> hibernation_snapshot(). If we happen to encounter an error further down
> the road or if we are exiting early due to a successful freezer test,
> then thaw kernel threads before returning to the caller.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks. :)

-- 
tejun
