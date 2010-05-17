Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0EQSuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:50:54 -0400
Received: from 152.Red-88-2-254.staticIP.rima-tde.net ([88.2.254.152]:42622
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755346Ab0EQSuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:50:52 -0400
Date: Mon, 17 May 2010 20:50:49 +0200
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Norbert Preining <preining@logic.at>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ipheth device not showing up
Message-ID: <20100517185049.GA6110@bart.evergreen.loc>
Mail-Followup-To: Norbert Preining <preining@logic.at>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= <ariveira@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20100511165159.GA9614@gamma.logic.tuwien.ac.at>
 <20100511205918.70c21413@varda>
 <20100512024258.GB14797@gamma.logic.tuwien.ac.at>
 <20100512160216.GA9548@srcf.ucam.org>
 <20100512160730.GP16168@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100512160730.GP16168@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 01:07:31AM +0900, Norbert Preining wrote:
> On Mi, 12 Mai 2010, Matthew Garrett wrote:
> > On Wed, May 12, 2010 at 11:42:58AM +0900, Norbert Preining wrote:
> > 
> > > Sorry, forgot that, pairing program is called, but does not change
> > > anything. It is called automatically by udev, but I also tried manually.
> > 
> > Have you enabled tethering on your phone?
> 
> Yes, of course.
> 

Hi,

I've found some times when testing a proper network manager that it doesn't show
up using ifconfig but the kernel detects it (using /proc or /sys you can see the
device).

Have you tried an udev/dbus enabled network manager?


Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
