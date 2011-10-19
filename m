Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1JSHfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:35:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:36930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1JSHf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:35:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,370,1315206000"; 
   d="scan'208";a="75338393"
Subject: Re: iwlagn is getting very shaky
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Norbert Preining <preining@logic.at>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAOJsxLHLmtYAR1c34Kkn+hzGeOSwhU646PP04pvTFx2e5M0NfA@mail.gmail.com>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com>
	 <1319003710.31823.53.camel@wwguy-huron>
	 <20111019064818.GB14817@gamma.logic.tuwien.ac.at>
	 <1319004938.31823.59.camel@wwguy-huron>
	 <CAOJsxLHLmtYAR1c34Kkn+hzGeOSwhU646PP04pvTFx2e5M0NfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 23:44:59 -0700
Message-ID: <1319006699.31823.65.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 00:19 -0700, Pekka Enberg wrote:
> Hi Wey,
> 
> On Wed, Oct 19, 2011 at 9:15 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > Sorry, I was thinking ask Pekka to use the officialfirmware. But more
> > important, I will like to find out is Pekka has the same issue as you
> > have which is tx queue stopped.
> 
> I'm happy to help but I have no idea what you want me to do :-). When
> my internet connection dies the next time, what do you want me to
> capture for you? What's official firmware? I'm using Fedora 15 with
> 3.1-rc9 built from sources here. Do you want to see my lspci, .config,
> dmesg, something else?

I don't think it is firmware problem, so please ignore :-)
> 
> As for the problems, I'm using iPhone 3G internet via WiFi sharing and
> connection seems to die few times a day or if I take the phone far
> enough from the laptop. I usually turn off the AP for a while and use
> NetworkManager on the laptop to disable/enable networking to make it
> come back up.
> 
> I haven't tested anything but 3.1-rcX kernels on this machine but I
> can do git bisect too if it comes to that.
> 
I am just try to understand if you encounter the same problem as
Norbert. if you can dump the tx_queue
in /sys/kernel/debug/ieee80211/phX/iwlagn/debug folder and send me the
log, thsat will be great.


p.s. you will need to enable CONFIG_IWLWIFI_DEBUGFS option in
your .config

Thanks
Wey
>                         Pekka


