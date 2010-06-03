Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0FCVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:32:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:43569 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab0FCVcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,357,1272870000"; 
   d="scan'208";a="284773670"
Subject: Re: iwl3945 bug in 2.6.34
From: reinette chatre <reinette.chatre@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274830187.2091.17034.camel@rchatre-DESK>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
	 <1274726029.2091.15160.camel@rchatre-DESK>
	 <1274738896.2091.15438.camel@rchatre-DESK>
	 <1274830187.2091.17034.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 14:32:17 -0700
Message-ID: <1275600737.2091.32332.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satish,

On Tue, 2010-05-25 at 16:29 -0700, reinette chatre wrote:
> On Mon, 2010-05-24 at 15:08 -0700, reinette chatre wrote:
> > On Mon, 2010-05-24 at 11:33 -0700, reinette chatre wrote:
> > > On Sat, 2010-05-22 at 23:25 -0700, Satish Eerpini wrote:
> > > 
> > > > No probe response from AP 00:1b:da:2a:a1:53 after 500ms, disconnecting.
> > > > iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> > > > iwl3945 0000:10:00.0: Error setting new configuration (-110).
> > > > iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> > > > iwl3945 0000:10:00.0: Error setting new configuration (-110).
> > > 
> > > This did not use to be an issue with 3945 and unfortunately we do not
> > > know what is triggering it now. Please try the "Enable stuck queue
> > > detection on 3945" patch that is attached to
> > > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1834 as a
> > > workaround.
> > 
> > Actually, sorry, but that patch will not work on 2.6.34 since the
> > feature it enables is not present there - it will be in 2.6.35 though.
> > To enable the feature in 2.6.34 will take some more backporting effort
> > that I'm looking into now.
> 
> Please try the attached two patches.

Were you able to test these patches?

Thanks

Reinette


