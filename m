Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab0CaKBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:01:06 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:35937 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab0CaKBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:01:04 -0400
X-Greylist: delayed 1774 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 06:01:04 EDT
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4BB3166C.70408@tudelft.nl>
Date: Wed, 31 Mar 2010 11:31:24 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100325 Mandriva/3.0.3-2mdv2010.1 (2010.1) Thunderbird/3.0.3
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3 - nvidia: module license 'NVIDIA' taints kernel.
References: <y2r40a4ed591003310218he411c263p62915a3e0a5a8de3@mail.gmail.com>
In-Reply-To: <y2r40a4ed591003310218he411c263p62915a3e0a5a8de3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/10 11:18, Zeno Davatz wrote:
> Ok, I just booted into the new 2.6.34-rc3 Kernel. Looks Lovely!
:
> resource map sanity check conflict: 0x9f800 0xa07ff 0xa0000 0xbffff
:
> Info: mapping multiple BARs. Your kernel is fine.
:
> 
> Can I ignore this or is this of any use for the list and the Kernel improvement?
Hi,
This is not tainting, it's a resource conflict. That check has just been
added to the kernel, that's why it did not happen before. As mentioned
in the log, your kernel is fine.

As the conflict is happening with the proprietary driver, the only
action you can do is to contact NVidia. Maybe they'll fix it in a later
version...

See you,
Eric
