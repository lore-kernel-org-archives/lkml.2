Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0EJIsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0EJIsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:48:36 -0400
Message-ID: <4BE7C857.1000600@redhat.com>
Date: Mon, 10 May 2010 11:48:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>, Dexuan Cui <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v3 0/2] x86 FPU API
References: <1273135546-29690-1-git-send-email-avi@redhat.com>
In-Reply-To: <1273135546-29690-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 11:45 AM, Avi Kivity wrote:
> Currently all fpu accessors are wedded to task_struct.  However kvm also uses
> the fpu in a different context.  Introduce an FPU API, and replace the
> current uses with the new API.
>
> While this patchset is oriented towards deeper changes, as a first step it
> simlifies xsave for kvm.
>    

Peter/Ingo, what are the plans for merging it?  The kvm xsave work 
depends on this.

-- 
error compiling committee.c: too many arguments to function

