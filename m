Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1LVOhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:37:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1LVOhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:37:48 -0500
Date: Thu, 22 Dec 2011 08:47:11 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hamo <hamo.by@gmail.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: ensure that debugfs entries have been created
Message-ID: <20111222104711.GA7816@amt.cnet>
References: <CAO_0yfMXeTz0B2YZHGUHGUFr=SE+-oT=VU5y5agn5N954pPpLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_0yfMXeTz0B2YZHGUHGUFr=SE+-oT=VU5y5agn5N954pPpLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 02:23:16PM +0800, Hamo wrote:
> by checking the return value from kvm_init_debug, we
> can ensure that the entries under debugfs for KVM have
> been created correctly.
> 
> Signed-off-by: Yang Bai <hamo.by@gmail.com>

Applied, thanks.

