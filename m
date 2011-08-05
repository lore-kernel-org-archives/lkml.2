Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1HEBvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 21:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab1HEBvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 21:51:00 -0400
Date: Thu, 4 Aug 2011 21:50:57 -0400
From: Dave Jones <davej@redhat.com>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tom.l.nguyen@intel.com,
        yanmin.zhang@intel.com
Subject: Re: [rfc] suppress excessive AER output
Message-ID: <20110805015057.GB19434@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	huang ying <huang.ying.caritas@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, tom.l.nguyen@intel.com,
	yanmin.zhang@intel.com
References: <20110803223407.GA20646@redhat.com>
 <CAC=cRTM_CZfstvbpdCRrLV-VH0VC=u6r10L+Ox2G4LWomXVauA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC=cRTM_CZfstvbpdCRrLV-VH0VC=u6r10L+Ox2G4LWomXVauA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 02:45:01PM +0800, huang ying wrote:
 > On Thu, Aug 4, 2011 at 6:34 AM, Dave Jones <davej@redhat.com> wrote:
 > > I have a machine that has developed some kind of problem with
 > > its onboard ethernet.  It still boots, but spewed almost 1.5G of text
 > > (2381585 instances of the warning below) before we realised what
 > > was going on, and blacklisted the igb driver.
 > >
 > > Is it worth logging every single error when we're flooding like this ?
 > > It seems unlikely that we'll find useful information in amongst that much data
 > > that wasn't already in the first 100 instances.
 > >
 > > I picked 100 in the (untested) example patch below arbitarily, but the exact
 > > value could be smaller, or slightly bigger..
 > >
 > > could we do something like this maybe ?
 > 
 > Why not use __ratelimit to implement this feature?

that would be better than the current situation probably, but my gut feeling is
that there's still going to be a lot of spew.

	Dave

