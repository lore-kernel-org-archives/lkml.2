Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab2E1HVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 03:21:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab2E1HVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 03:21:23 -0400
Date: Mon, 28 May 2012 10:21:18 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: introduce readonly memory region
Message-ID: <20120528072118.GE4369@redhat.com>
References: <4FBDFE52.5090902@linux.vnet.ibm.com>
 <4FBE2521.1050800@redhat.com>
 <4FBF471E.9080809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBF471E.9080809@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 04:47:26PM +0800, Xiao Guangrong wrote:
> By the way, a foolish question, what is ROMD?  i did not find any explanation
> on google.
This is memory region that behaves like ROM on read and like a device on
write. IIRC some flash chips are like that.

--
			Gleb.
