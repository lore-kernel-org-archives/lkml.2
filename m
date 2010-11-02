Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0KBG71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 02:59:27 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:44637 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab0KBG7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 02:59:20 -0400
Subject: Re: [RFD] Device Renaming Mechanism
From: Jon Masters <jonathan@jonmasters.org>
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: gregkh@suse.de, James.Bottomley@suse.de, rwheeler@redhat.com,
        linux-kernel@vger.kernel.org,
        linux-hotplug-devel@lists.sourceforge.net,
        linux-hotplug@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        mdomsch@dell.com
In-Reply-To: <4CAEAAD4.2080504@hitachi.com>
References: <4CAEAAD4.2080504@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 02 Nov 2010 03:00:08 -0400
Message-ID: <1288681208.3916.170.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 14:23 +0900, Nao Nishijima wrote:

> I'm trying to solve a device name(or device node) mismatch problem caused by
> device configuration changes. Now I have an idea of device renaming to solve it,
> and would like to request for comments from kernel developers.

I apologize that I missed this mail until I was doing some podcasts ;)

Although not necessarily useful for within-device volumes, I would
nonetheless like to call attention to the DMTF SMBIOS specification, and
in particular structure Type 9, which allows system vendors to provide
various information about the correct mappings of physical system slots
to devices. Matt Domsch produced a utility a while back called
biosdevname that can be used to implement one possible device renaming
mechanism for network interfaces, based on the system slot identifier,
but of course there is no reason not to support the other devices.

I have read the other mails, but I would love to know what Greg and Kay
think about supporting automatic renaming in the case where the system
*actually told you the preferred name* in such a table. Perhaps we can
discuss this in Cambridge this week.

Jon.


