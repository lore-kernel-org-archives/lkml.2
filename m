Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1DTAKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:10:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:36788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab1DTAKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:10:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,242,1301900400"; 
   d="scan'208";a="735782839"
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com>
	 <1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 19 Apr 2011 17:10:22 -0700
Message-ID: <1303258222.13457.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 16:22 -0700, David Rientjes wrote:
> On Tue, 19 Apr 2011, james_p_freyensee@linux.intel.com wrote:
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
> Acked-by: David Rientjes <rientjes@google.com>
> 
> There've been some other patchsets proposed recently that need to print a 
> thread's comm and since /proc/pid/comm can change the comm's of other 
> threads out from under them, it's necessary to serialize access to it with 
> task_lock().  This patch certainly makes it easier for modules to do so 
> correctly, thanks!

Thanks for the compliment; it's appreciated.  I've made my patch sets
independent from one another.  And I believe a common consensus (at
least with Greg KH, Alan C., Arjan VdV and myself) was achieved that
this is a good patch to apply? So maybe this can be applied to the
kernel, independent of my other patches, so this will fit your needs?


