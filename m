Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0LJOuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:50:14 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57384 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab0LJOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:50:13 -0500
Message-ID: <4D023E22.6090509@canonical.com>
Date: Fri, 10 Dec 2010 15:50:10 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [stable] Linux 2.6.32.27+drm33.12
References: <1291991638-8203-1-git-send-email-stefan.bader@canonical.com> <4D023C3E.7070608@example.com>
In-Reply-To: <4D023C3E.7070608@example.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 03:42 PM, Piotr Hosowicz wrote:
> On 10.12.2010 15:33, Stefan Bader wrote:
>> I am announcing the release of the 2.6.32.27+drm33.12 stable tree.
> 
> Would you please highlight main assets of this kernel? I could try
> something new.
> 
> Regards,
> 
> Piotr Hosowicz
> 

As described in the body of the announcement this tree is a 2.6.32 stable tree
with all the drm code backported from 2.6.33 (plus stable patches for that).
It is basically what the Debian and Ubuntu 2,.6.32 kernels are based on (as the
2.6.32 drm code was seen as too bad).

I am maintaining that tree on kernel.org, so Debian and us (or whoever had need
for that Frankenkernel solution) to have a shared place to maintain this hybrid
stable.

-Stefan

