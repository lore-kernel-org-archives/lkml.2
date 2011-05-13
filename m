Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab1EMJ55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:57:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:8722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab1EMJ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:57:56 -0400
Message-Id: <8f4a6f$m83rlu@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,363,1301900400"; 
   d="scan'208";a="746712766"
Date: Fri, 13 May 2011 10:57:52 +0100
To: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
Subject: Re: patch from intel-drm-staging for 2.6.39
Cc: dri-devel@lists.freedesktop.org
References: <iqit3p$oka$1@dough.gmane.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <iqit3p$oka$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 09:19:53 +0000 (UTC), Frederik Himpe <fhimpe@telenet.be> wrote:
> This commit from intel-drm-staging fixes an oops for me when docking my 
> system. Can it be added to 2.6.39?

Dave added it to his next queue as he wanted to validate the patch on
several machines (not just Intel) with lockdep. Once he's happy that it is
unlikely to cause other regressions, he will send it on and from there we
can ask for it to be put into stable.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
