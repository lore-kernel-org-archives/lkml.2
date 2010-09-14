Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0INO2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:28:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:31169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0INO2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:28:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,365,1280732400"; 
   d="scan'208";a="606786930"
Date: Tue, 14 Sep 2010 14:43:45 +0100
From: Alan Cox <alan@linux.intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, greg@kroah.com,
        x86@kernel.org
Subject: Re: [PATCH v3 1/4] x86, mrst: make mrst_identify_cpu() inlne inside
 mrst.h
Message-ID: <20100914144345.49e05674@linux.intel.com>
In-Reply-To: <1284361736-23011-2-git-send-email-feng.tang@intel.com>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
	<1284361736-23011-2-git-send-email-feng.tang@intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 15:08:53 +0800
Feng Tang <feng.tang@intel.com> wrote:

> Otherwise there will be some compilation warning for those .c
> files which include mrst.h

I've sent this to Ingo four or five times already and been ignored.
