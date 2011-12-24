Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1LXO3C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 09:29:02 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63290 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1LXO25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 09:28:57 -0500
MIME-Version: 1.0
In-Reply-To: <20111224142028.GA32171@srcf.ucam.org>
References: <87ty4ss0z4.fsf@prochyra.name>
	<CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com>
	<87ty4qdpna.fsf@prochyra.name>
	<20111224142028.GA32171@srcf.ucam.org>
Date: Sat, 24 Dec 2011 15:28:56 +0100
Message-ID: <CANq1E4S+Sa1BERtR6aNH-ypRo+oJ1fRXkuVa+tREy5qVodv2pw@mail.gmail.com>
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for Samsung
 N150 Plus
From: David Herrmann <dh.herrmann@googlemail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrzej Prochyra <andrzej@prochyra.name>,
        Corentin Chary <corentin.chary@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 3:20 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sat, Dec 24, 2011 at 02:12:57PM +0000, Andrzej Prochyra wrote:
>> 'acpi_video0' not functional.  Brightness can be controlled through
>> intel_backlight interface.  There are 21 brightness levels and the
>> backlight can be turned off.
>
> If acpi_video0 doesn't work then we either need to work out why it's not
> working or make it vanish completely, so this patch isn't the correct
> approach.

Just to make clear, intel_backlight isn't working properly either. If
my laptop boots with backlight at 50% then intel_backlight will only
work in the range 0%-50% on my machine. If I use the samsung module to
set it to 100% then  intel_backlight works correctly in the range
0-100% until next reboot/suspend.

So I'd recommend staying with the samsung module and disabling the
acpi_backlight entirely. The samsung module is the only backlight
control which works properly.

Regards
David
