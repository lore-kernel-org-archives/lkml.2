Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab0JEMl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:41:59 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36746 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0JEMl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:41:57 -0400
Subject: Re: [PATCH 3/5] misc: Driver for APDS990X ALS and proximity sensors
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101005140049.1f25bb24@lxorguk.ukuu.org.uk>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
	 <1286271779-19819-4-git-send-email-samu.p.onkalo@nokia.com>
	 <20101005122323.2d2870ee@lxorguk.ukuu.org.uk>
	 <1286279313.21781.29.camel@4fid08082>
	 <20101005140049.1f25bb24@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Tue, 05 Oct 2010 15:39:44 +0300
Message-Id: <1286282384.21781.62.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Oct 2010 12:39:50.0170 (UTC) FILETIME=[66B69FA0:01CB648A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 15:00 +0200, ext Alan Cox wrote:
> > > - not clear how power_state and runtime pm interact - do we in fact need
> > >   power state ?
> > 
> > power_state turns chip on or off. In off state runtime pm is used to
> > handle bookkeeping and also handling chip state transitions including
> > regulators. Other ideas than separate power_state for this kind of
> > control? 
> 
> Ok that makes sense.
> 
> > 
> > 
> > > - lux0_input range being fixed seems inconvenient, the sensors I've got
> > >   queued here use lux0_input as you do but also provide a read (and
> > >   optionally writable) range limit in lux
> > > 
> > > static DEVICE_ATTR(lux0_sensor_range, S_IRUGO | S_IWUSR,
> > > 	als_sensing_range_show, als_sensing_range_store);
> > > 
> > > and in your case you could just return 65535
> > > 
> > 
> > I'll add that
> 
> Cool. I'll bash our sensor queue to fit this API

There are quite many naming convetion changes proposed
by Jonathan Cameron. I think that those are valid.

-Samu



