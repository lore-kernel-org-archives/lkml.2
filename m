Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2FFM2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:28:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:35042 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FFM2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:28:10 -0400
Message-ID: <1338985676.2749.109.camel@twins>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel
 machines
From: Peter Zijlstra <peterz@infradead.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com, bp@amd64.org, x86@kernel.org
Date: Wed, 06 Jun 2012 14:27:56 +0200
In-Reply-To: <4FCF4BFE.6090103@linux.intel.com>
References: <20120524174943.989990966@linutronix.de>
	 <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com>
	 <alpine.LFD.2.02.1206042158200.3086@ionos>
	 <4FCDF1C8.9020007@linux.intel.com>
	 <alpine.LFD.2.02.1206051503560.3086@ionos>
	 <4FCF0500.9050704@linux.intel.com>
	 <alpine.LFD.2.02.1206061056520.3086@ionos>
	 <alpine.LFD.2.02.1206061215250.3086@ionos>
	 <4FCF4BFE.6090103@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 20:24 +0800, Chen Gong wrote:
> I will continue to do more tests on tomorrow. 

You've got a TARDIS? Neat!
