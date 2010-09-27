Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab0I0GOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:14:06 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40330 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730Ab0I0GOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:14:02 -0400
Date: Mon, 27 Sep 2010 08:13:58 +0200
From: Florian Mickler <florian@mickler.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Berg, Johannes" <johannes.berg@intel.com>, Zhu Yi <yi.zhu@intel.com>,
        "Cahill, Ben M" <ben.m.cahill@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwl3945: queue the right work if the scan needs to be
 aborted
Message-ID: <20100927081358.07b30327@schatten.dmk.lab>
In-Reply-To: <1285357868.12594.8.camel@wwguy-ubuntu>
References: <1285345323-4250-1-git-send-email-florian@mickler.org>
	<1285357868.12594.8.camel@wwguy-ubuntu>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 12:51:08 -0700
"Guy, Wey-Yi" <wey-yi.w.guy@intel.com> wrote:

> Hi Florian,
> 
> Thanks for sending the patch, the scan operation in iwlwifi just being
> modified and the changes you have no longer apply.please check the
> latest kernel.
> 
> Thanks
> Wey
> 

Ok, I checked out
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
and it definitely looks better in there. This patch shouldn't be
necessary for that. 

Do you plan on submitting this for 2.6.36 or .37?

I think my patch should fix the instance reported in the bug in a less
invasive manner. 
Only remaining question is why it did only show up now. But that's
probably due to the workqueue changes.


Regards,
Flo
