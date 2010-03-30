Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0C3WFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:05:11 -0400
Received: from capside.net ([81.19.98.74]:50122 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab0C3WFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:05:08 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 18:05:08 EDT
Message-ID: <4BB273FE.8010004@sysvalve.es>
Date: Tue, 30 Mar 2010 23:58:22 +0200
From: =?ISO-8859-1?Q?=22L=2E_Alberto_Gim=E9nez=22?= 
	<agimenez@sysvalve.es>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, alan@linux.intel.com
Subject: Re: [PATCH] Staging: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>	<1269984864-28159-2-git-send-email-agimenez@sysvalve.es> <20100330214509.GA1388@suse.de>
In-Reply-To: <20100330214509.GA1388@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 11:45 PM, Greg KH wrote:
> On Tue, Mar 30, 2010 at 11:34:24PM +0200, L. Alberto Gim??nez wrote:
>> Add new driver to use tethering with an iPhone device to the staging tree.
> 
> Why the staging tree?
> 
> What is wrong with the driver that it needs to go there and not to the
> main kernel tree?
> 

Sorry, I thought that the first step was getting into staging. I ignored
the fact that it needed a TODO file. I'm not either sure about where
should it go since it uses the USB interface but in fact is used as a
network device (drivers/net? drivers/usb?). My guess is drivers/net, but
I'm pretty sure I'm wrong :)

> Did you write this driver?  If not, please put a "From:" line that shows
> who did write it.

Should I just add a "From: " email-like header in the patch, in the
commit or in the body? I'm not sure how to do it.

Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
