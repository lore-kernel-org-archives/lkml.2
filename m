Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0JYMMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:12:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0JYMMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:12:33 -0400
Date: Mon, 25 Oct 2010 14:05:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
Message-ID: <20101025120545.GA17337@redhat.com>
References: <20101025012124.GA31262@redhat.com>
 <4CC548C1.3060009@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC548C1.3060009@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 11:07:13AM +0200, Jan Kiszka wrote:
> Cool, seems to be the key to the corruptions I've seen. Applying your
> patch make them disappear.

Yes, works for me as well.

-- 
MST
