Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1AGWhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:37:05 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46460 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1AGWhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:37:02 -0500
Message-ID: <4D279589.1060107@canonical.com>
Date: Fri, 07 Jan 2011 17:36:57 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nikolai Kondrashov <spbnick@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add evdev type and code definitions
References: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com> <4D278E6B.7020002@gmail.com> <4D279075.4080503@canonical.com> <4D279325.3040205@gmail.com>
In-Reply-To: <4D279325.3040205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 05:26 PM, Nikolai Kondrashov wrote:
> On 01/08/2011 01:15 AM, Chase Douglas wrote:
>> Hmm.. That seems incorrect to me. Why wouldn't it follow the behavior
>> outlined above?
> Because the tablet doesn't report when the tool enters/leaves the proximity.
> It just starts/stops sending the coordinates.
> 
> A leave timer could be used, though. Maybe we could ignore the case when the
> mouse is laying still on the tablet or the pen is held very steadily in
> place and just tell that tool left the surface.
> 
> Maybe it will be beneficial to have it synthesised after all, as it would
> probably ease the integration with xf86-input-wacom and will keep the evdev
> protocol more consistent.

I think I understand now, and it sounds pretty broken :). Do we want to
codify such behaviour, or leave it out as a special case? I don't see
this document as a definitive guide to evdev usage and driver
development, just a reference and best practices guide, so I'm inclined
to say the latter.

-- Chase
