Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3AFGn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 01:43:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:33857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3AFGnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 01:43:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,418,1355126400"; 
   d="scan'208";a="240459359"
Date: Sat, 5 Jan 2013 22:43:54 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v4 07/18] perf: add generic memory sampling interface
Message-ID: <20130106064354.GK29714@tassilo.jf.intel.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-8-git-send-email-eranian@google.com>
 <20130105190552.GC995@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130105190552.GC995@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why dont use enums for this?

enums can have unpredictable signed/unsignedness issues. #defines for
hardware constants is usually far safer.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
