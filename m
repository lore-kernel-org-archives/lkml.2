Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1EEQ7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:59:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:24504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1EEQ7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:59:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,321,1301900400"; 
   d="scan'208";a="638567173"
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <alpine.DEB.2.00.1104251357260.31884@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com>
	 <1303515150-1718-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.DEB.2.00.1104251357260.31884@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 05 May 2011 09:59:36 -0700
Message-ID: <1304614776.8860.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 13:57 -0700, David Rientjes wrote:
> On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:
> 
> > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > This allows drivers who call this function to be compiled modularly.
> > Otherwise, a driver who is interested in this type of functionality
> > has to implement their own get_task_comm() call, causing code
> > duplication in the Linux source tree.
> > 
> > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> Third time:
> 
> Acked-by: David Rientjes <rientjes@google.com>

Okay, so you want me to add an 'acked-by' next time on this patch in my
patch-set series?

