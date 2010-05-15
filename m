Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0EOV4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:56:00 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60033 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0EOVz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:55:58 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH] Staging: quatech_usb2: Convert eos semaphore to mutex
Date: Sat, 15 May 2010 23:55:54 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Bill Pemberton <wfp5p@virginia.edu>, Jiri Kosina <jkosina@suse.cz>,
       Javier Martinez Canillas <martinez.javier@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1273959602-15465-1-git-send-email-abogani@texware.it>
In-Reply-To: <1273959602-15465-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005152355.54762.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 15. Mai 2010 23:40:02 schrieb Alessio Igor Bogani:
> The eos semaphore is used as a mutex so replace it with a real mutex.

Documentation/mutex-design.txt states that a mutex must not be used
from within an interrupt handler. Is this outdated?

	Regards
		Oliver
