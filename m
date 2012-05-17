Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495Ab2EQJZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761400Ab2EQJZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:25:16 -0400
Message-ID: <4FB4C3F7.2080204@redhat.com>
Date: Thu, 17 May 2012 12:25:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
References: <20120516175856.GD10769@redhat.com> <20120516181500.GA23791@amt.cnet> <20120516182520.GH28798@redhat.com> <20120516182948.GF10769@redhat.com> <20120516183822.GI28798@redhat.com> <20120516190757.GA12113@redhat.com> <20120517072841.GW32036@redhat.com> <20120517074946.GA27995@redhat.com> <4FB4AF6D.9080305@redhat.com> <20120517091054.GE27995@redhat.com> <20120517091250.GA10209@redhat.com>
In-Reply-To: <20120517091250.GA10209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 12:12 PM, Gleb Natapov wrote:
> > 
> > OK will look into this next week.
> > 
> What about looking into my suggestion with setting vcpu->request bit? I
> think totally refactoring irq handling path should not be done as part
> of this series.
>

Certainly not as part of it, but maybe as a prerequisite.

-- 
error compiling committee.c: too many arguments to function

