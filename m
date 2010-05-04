Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab0EDSNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:13:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:6740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760103Ab0EDSNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:13:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,328,1270450800"; 
   d="scan'208";a="564068077"
Subject: Re: [PATCH 2/2] x86: Introduce 'struct fpu' and related API
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Cui, Dexuan" <dexuan.cui@intel.com>, Sheng Yang <sheng@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <1272812038-32484-3-git-send-email-avi@redhat.com>
References: <1272812038-32484-1-git-send-email-avi@redhat.com>
	 <1272812038-32484-3-git-send-email-avi@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 04 May 2010 11:12:31 -0700
Message-Id: <1272996751.2833.10.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-02 at 07:53 -0700, Avi Kivity wrote:
> Currently all fpu state access is through tsk->thread.xstate.  Since we wish
> to generalize fpu access to non-task contexts, wrap the state in a new
> 'struct fpu' and convert existing access to use an fpu API.
> 
> Signal frame handlers are not converted to the API since they will remain
> task context only things.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

One comment I have is the name 'fpu'. In future we can use this for non
fpu state aswell. For now, I can't think of a simple and better name. We
can perhaps change it in the future.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

