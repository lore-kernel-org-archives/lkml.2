Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1EBM4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:56:54 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34679 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756167Ab1EBM4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:56:53 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net E0BFD108347
Message-ID: <4DBEAA12.5040801@df1tl.local.here>
Date: Mon, 02 May 2011 14:56:50 +0200
From: Klaus Dittrich <kladit@arcor.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.17) Gecko/20110429 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.5-rc1 usb problem
References: <20110502083117.GA1968@df1tl.local.here> <201105021057.11886.oneukum@suse.de> <4DBE8B88.2080104@df1tl.local.here> <201105021252.30677.oneukum@suse.de>
In-Reply-To: <201105021252.30677.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I did some further tests.

When I switch on the scanner I gets not recognized. as described before.

If I then disconnect the usb-cable, of the already switched on scanner, 
and then reconnect it, the scanner gets recognized.

new full speed USB device using uhci_hcd
Product: Perfection1640
Manufacturer: EPSON

A timing problem?

My camera, has no problems.

new high speed USB device using ehci_hcd
Product: Canon Digital Camera
Manufacturer: Canon Inc.


Hope this helps to localise the problem.

-- 

Klaus
