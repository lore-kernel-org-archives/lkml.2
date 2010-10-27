Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab0J0USi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:18:38 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:54704 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0J0USg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:18:36 -0400
Date: Wed, 27 Oct 2010 21:18:33 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: [rfc -tip 0/2] Implementing self IPI with NMI destination
In-Reply-To: <20101027195352.996250316@openvz.org>
Message-ID: <alpine.LFD.2.00.1010272113001.6079@eddie.linux-mips.org>
References: <20101027195352.996250316@openvz.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Cyrill Gorcunov wrote:

>  Here is self-IPI with NMI destination implemented. Don was testing
> perf NMI's and we found that we don't have a simple call for self-nmi IPI.

 I'm completely swamped with binutils stuff these days, and I've got a 
couple of outstanding issues to deal with before the imminent 2.21 release 
-- I'll try to pinch some time and have a look at your patches over the 
weekend, but please forgive me if I don't (and ping me sometime next week 
then).

  Maciej
