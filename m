Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab1LPLGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:06:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab1LPLGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:06:22 -0500
Date: Fri, 16 Dec 2011 07:38:13 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Liu Ping Fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        gleb@redhat.com, jan.kiszka@web.de
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111216093813.GB26982@amt.cnet>
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>
 <1323923328-917-1-git-send-email-kernelfans@gmail.com>
 <4EE99846.5080302@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE99846.5080302@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 03:48:38PM +0900, Takuya Yoshikawa wrote:
> (2011/12/15 13:28), Liu Ping Fan wrote:
> > From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
> > 
> > Currently, vcpu can be destructed only when kvm instance destroyed.
> > Change this to vcpu's destruction before kvm instance, so vcpu MUST
> > and CAN be destroyed before kvm's destroy.
> 
> Could you explain why this change is needed here?
> Would be helpful for those, including me, who will read the commit later.

I fail to see the motivation for this change also.

