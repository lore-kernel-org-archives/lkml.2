Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2DRRVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:21:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35111 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2DRRVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:21:01 -0400
Date: Wed, 18 Apr 2012 18:20:50 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Bastien Nocera <hadess@hadess.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        Richard Hughes <richard@hughsie.com>
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
Message-ID: <20120418172050.GA2651@srcf.ucam.org>
References: <20120418140517.GM19507@zod.bos.redhat.com>
 <1334758134.8818.132.camel@novo.hadess.net>
 <20120418141131.GN19507@zod.bos.redhat.com>
 <20120418142450.GA30083@srcf.ucam.org>
 <4F8EF601.1050804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8EF601.1050804@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:12:33AM -0700, Jeremy Fitzhardinge wrote:
> Does upower trigger a shutdown/hibernation if *any* power supply is low,
> or just if all of them are?  Are the failing cases ones where the BT
> keyboard is the only visible power supply?

We're seeing shutdowns on desktop machines using bluetooth devices, yes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
