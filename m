Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1ASILJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:11:09 -0500
Received: from smtp.nokia.com ([147.243.128.24]:56223 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1ASILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:11:08 -0500
Subject: Re: CONFIG_NFC_DEVICES
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m3lj2idmgd.fsf@jhcloos.com>
References: <m3lj2idmgd.fsf@jhcloos.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Wed, 19 Jan 2011 10:10:53 +0200
Message-ID: <1295424653.25951.68.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 14:46 -0500, ext James Cloos wrote:
> The help text for 'menuconfig NFC_DEVICES' should mention that NFC is
> Near-Field Communication.  'config PN544_NFC' does, but one does not
> see that until/unless one selects NFC_DEVICES.
> 
> That it was easy to cypher out shouldn't prevent explicit mention.

Ok, fair point. I'll make a patch for it.

Thanks,
Matti

> 
> -JimC


