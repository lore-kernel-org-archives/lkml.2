Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1GZW7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:59:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46135 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1GZW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:59:39 -0400
Message-ID: <4E2F46D5.6060206@canonical.com>
Date: Tue, 26 Jul 2011 15:59:33 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: djkurtz@chromium.org, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 1/9 v2] Input: synaptics - refactor y inversion
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org> <1311169146-20066-2-git-send-email-djkurtz@chromium.org> <20110725082752.GB22937@core.coreip.homeip.net>
In-Reply-To: <20110725082752.GB22937@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 01:27 AM, Dmitry Torokhov wrote:
> On Wed, Jul 20, 2011 at 09:38:58PM +0800, djkurtz@chromium.org wrote:
>> From: Daniel Kurtz <djkurtz@chromium.org>
>>
>> Synaptics touchpads report increasing y from bottom to top.
>> This is inverted from normal userspace "top of screen is 0" coordinates.
>> Thus, the kernel driver reports inverted y coordinates to userspace.
>>
>> This patch refactors this inversion.
>>
> 
> I really do not see the point...

It's easier for me to read and comprehend, at least. I agree that it's
really really minor, but if it's in the middle of 10 other patches, then
I don't have a problem with it.

-- Chase
