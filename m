Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab0LUQpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:45:36 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33796 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0LUQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:45:34 -0500
Message-ID: <4D10D9A1.2070307@canonical.com>
Date: Tue, 21 Dec 2010 11:45:21 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Chris Bagwell <chris@cnpbagwell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/4] Input: synaptics - add multitouch packet support
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se> <1292683981-6908-2-git-send-email-rydberg@euromail.se> <AANLkTimrNrfTXGh675_8zhOg_+9+NKgOmzJq9rafyh+6@mail.gmail.com> <20101218175408.GA1709@polaris.bitmath.org>
In-Reply-To: <20101218175408.GA1709@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 12:54 PM, Henrik Rydberg wrote:
> All in all, this patchset contains enough information to resolve
> jumping and clickpad issues in user space, at the same time as it
> keeps compatibility with mousedev and older hardware. We know there
> are still issues, but I see no real reason to postpone these changes
> any further.

My only concern is that by enabling MT mode we may get different ST
values out of the device. However, I don't have concrete evidence that
it is worse, and we can probably fix it up, maybe with tracking, after
these patches are applied.

-- Chase
