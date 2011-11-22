Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1KVUyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:54:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:22930 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009Ab1KVUyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:54:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,555,1315206000"; 
   d="scan'208";a="88267197"
Subject: Re: 3.1+ iwlwifi lockup
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111122204741.GA3764@redhat.com>
References: <20111031143408.GA17152@redhat.com>
	 <1321992902.8072.7.camel@wwguy-ubuntu>  <20111122204741.GA3764@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 11:58:36 -0800
Message-ID: <1321991916.11647.77.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Not sure what happens, feel like memory corruption but not sure. the
contain of the command is totally bogus.

Could you please test and send update, it is part of "3.2+rc2+
Regressions from 3.0 and 3.1" reports

Thanks
Wey

On Tue, 2011-11-22 at 12:47 -0800, Dave Jones wrote:
> On Tue, Nov 22, 2011 at 12:15:02PM -0800, wwguy wrote:
>  > Hi Dave,
>  > 
>  > Sorry for taking so long.
>  > it is a bogus command from the firmware which driver try to process it
>  > and cause problem. I am not sure how it happen. But could you please try
>  > the patch I attach here.
>  > 
>  > For now I am just ignore the command, but not sure it is good enough,
>  > might has to reload the firmware, but not sure.
> 
> I can try the patch. Though FYI, I've not seen this bug again since I reported it.
> 
>  > Do you have a bugzilla# I can reference to?
> 
> no.
> 
> 	Dave


