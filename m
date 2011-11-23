Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1KWDZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:25:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:48038 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab1KWDZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:25:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="79073428"
Subject: Re: 3.1+ iwlwifi lockup
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111123024545.GA9703@redhat.com>
References: <20111031143408.GA17152@redhat.com>
	 <1321992902.8072.7.camel@wwguy-ubuntu>  <20111123024545.GA9703@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 18:29:40 -0800
Message-ID: <1322015380.11647.82.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Tue, 2011-11-22 at 18:45 -0800, Dave Jones wrote:
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
> With Linus' current tree and this patch, I got a panic pretty quickly,
> but with a different trace.
> 
Are you seeing the problem without this patch? I guess the patch I done
here is not the right thing to do and I try to address the problem too
aggressively

Thanks
Wey.




