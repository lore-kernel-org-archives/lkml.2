Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1HVPcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:32:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52501 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1HVPcC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:32:02 -0400
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Date: Mon, 22 Aug 2011 17:31:56 +0200
In-Reply-To: <20110822152154.GB2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
	 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
	 <1314022429.24275.30.camel@twins> <20110822152154.GB2067@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314027116.24275.70.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 11:21 -0400, Don Zickus wrote:
> It does seem odd, but I can change that to strncpy to
> be safer. 

I think kstrdup() exists for this purpose, don't forget to free it when
you're done with it though ;-)
