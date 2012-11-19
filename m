Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2KSLgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:36:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:26960 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab2KSLgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:36:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,279,1352102400"; 
   d="scan'208";a="219636028"
Date: Mon, 19 Nov 2012 11:38:28 +0000
From: Alan Cox <alan@linux.intel.com>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: gregkh@linuxfoundation.org, moinejf@free.fr, linux-kernel@vger.kernel.org
Subject: Re: vt: regression caused by "Fix line garbage in virtual.."
Message-ID: <20121119113828.5a66f112@bob.linux.org.uk>
In-Reply-To: <20121118110523.GA12094@shrek.podlesie.net>
References: <20121118110523.GA12094@shrek.podlesie.net>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There are some garbage after mousedev.c not present on older kernels.
> 
> Reverting commit 81732c in v3.7-rc6 fixes the issue.

Then we should drop this for 3.7 until a fixed one is provided IMHO.
Its not relevant to most platforms.
