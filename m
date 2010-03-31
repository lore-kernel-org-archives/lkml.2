Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0CaTrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:47:23 -0400
Received: from capside.net ([81.19.98.74]:51601 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab0CaTrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:47:21 -0400
Message-ID: <4BB3A6C2.6040603@sysvalve.es>
Date: Wed, 31 Mar 2010 21:47:14 +0200
From: =?ISO-8859-1?Q?=22L=2E_Alberto_Gim=E9nez=22?= 
	<agimenez@sysvalve.es>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg KH <gregkh@suse.de>, bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, alan@linux.intel.com
Subject: Re: [PATCH] Staging: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <1269984864-28159-2-git-send-email-agimenez@sysvalve.es> <20100330214509.GA1388@suse.de> <4BB273FE.8010004@sysvalve.es> <20100331143326.GA1843@ucw.cz>
In-Reply-To: <20100331143326.GA1843@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 04:33 PM, Pavel Machek wrote:
> On Tue 2010-03-30 23:58:22, "L. Alberto Gim?nez" wrote:
>> On 03/30/2010 11:45 PM, Greg KH wrote:
>>> On Tue, Mar 30, 2010 at 11:34:24PM +0200, L. Alberto Gim??nez wrote:
>>>> Add new driver to use tethering with an iPhone device to the staging tree.
> 
> Does it work out of the box, or is it some kind of driver for
> jailbroken iphones?

Hi Pavel, it works out of the box. You need some userspace tools used
also to access jailbroken devices, but this one does not need
specifically that your iPhone is jailbroken (mine is not, and it works
perfectly).

Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
