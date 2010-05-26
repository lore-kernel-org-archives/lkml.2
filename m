Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0EZHir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:38:47 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:62645 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab0EZHiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:38:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALds/EtbstI2/2dsb2JhbACeGnK/YA6FBQQ
Date: Wed, 26 May 2010 09:38:43 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] watchdog: f71808e_wdt: new watchdog driver
	for Fintek F71808E
Message-ID: <20100526073843.GJ3972@infomag.iguana.be>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk> <1269523063-30346-1-git-send-email-me@mortis.eu> <1269523063-30346-2-git-send-email-me@mortis.eu> <1269523063-30346-3-git-send-email-me@mortis.eu> <20100330090639.GA8822@salidar.me.mortis.eu> <20100520075229.GO4008@infomag.iguana.be> <20100525210824.GA7815@salidar.me.mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525210824.GA7815@salidar.me.mortis.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giel,

> > Driver looks OK to me. Can't apply it before the I/O resource sharing
> > is in place.  How do you want to proceed?
> 
> I would think applying it to watchdog-next to apply it for the next
> kernel release (similar to Jean Delvare's linux-next).

Will add it after 2.6.35-rc1 is out then.

Kind regards,
Wim.

