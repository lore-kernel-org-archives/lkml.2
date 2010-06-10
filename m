Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0FJNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:09:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0FJNJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:09:20 -0400
Date: Thu, 10 Jun 2010 15:09:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
       Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] HID: Add Support for Setting and Getting Feature
 Reports from hidraw
In-Reply-To: <1276098868-3262-1-git-send-email-alan@signal11.us>
Message-ID: <alpine.LNX.2.00.1006101508410.12271@pobox.suse.cz>
References: <1275969108-14948-1-git-send-email-alan@signal11.us> <1276098868-3262-1-git-send-email-alan@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, Alan Ott wrote:

> Per the HID Specification, Feature reports must be sent and received on
> the Configuration endpoint (EP 0) through the Set_Report/Get_Report
> interfaces.  This patch adds two ioctls to hidraw to set and get feature
> reports to and from the device.  Modifications were made to hidraw and
> usbhid.
> 
> New hidraw ioctls:
>   HIDIOCSFEATURE - Perform a Set_Report transfer of a Feature report.
>   HIDIOCGFEATURE - Perform a Get_Report transfer of a Feature report.

Hi Alan,

thanks for the patch. Could you please also update the Bluetooth 
implementation (in net/bluetooth/hidp/).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
