Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab1KVUrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:47:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab1KVUrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:47:45 -0500
Date: Tue, 22 Nov 2011 15:47:41 -0500
From: Dave Jones <davej@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.1+ iwlwifi lockup
Message-ID: <20111122204741.GA3764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	wwguy <wey-yi.w.guy@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20111031143408.GA17152@redhat.com>
 <1321992902.8072.7.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321992902.8072.7.camel@wwguy-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:15:02PM -0800, wwguy wrote:
 > Hi Dave,
 > 
 > Sorry for taking so long.
 > it is a bogus command from the firmware which driver try to process it
 > and cause problem. I am not sure how it happen. But could you please try
 > the patch I attach here.
 > 
 > For now I am just ignore the command, but not sure it is good enough,
 > might has to reload the firmware, but not sure.

I can try the patch. Though FYI, I've not seen this bug again since I reported it.

 > Do you have a bugzilla# I can reference to?

no.

	Dave
