Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2BAPo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:44:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab2BAPoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:44:23 -0500
Date: Wed, 1 Feb 2012 10:43:36 -0500
From: Dave Jones <davej@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
        Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120201154335.GA8494@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
 <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
 <20120125002250.GA20431@gamma.logic.tuwien.ac.at>
 <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
 <20120126003735.GA2346@gamma.logic.tuwien.ac.at>
 <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
 <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
 <20120126232555.GB16330@gamma.logic.tuwien.ac.at>
 <CANUX_P0z2800ip=yfW15zELqhDNFrHbTvDY3OF59PuxizN=XSA@mail.gmail.com>
 <20120131024143.GA10418@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131024143.GA10418@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 09:41:43PM -0500, Dave Jones wrote:
 
 >  > > Generally fine.
 >  > >
 >  > > Thanks, more reports later.
 >  > 
 >  > Dave ?
 > 
 > after running with it all evening, it seems to be working fine so far.

Two days later, it hasn't locked up at all, so this is definitly fixing my problem.

One thing though, dmesg is flooded with these..

[ 4384.849732] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0
[ 4434.332275] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0
[ 4475.309883] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0

Can it be supressed if the ra hasn't changed ?

	Dave

