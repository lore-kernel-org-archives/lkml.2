Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2DRRMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:12:38 -0400
Received: from claw.goop.org ([74.207.240.146]:50163 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2DRRMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:12:37 -0400
Message-ID: <4F8EF601.1050804@goop.org>
Date: Wed, 18 Apr 2012 10:12:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Josh Boyer <jwboyer@redhat.com>, Bastien Nocera <hadess@hadess.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        Richard Hughes <richard@hughsie.com>
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
References: <20120418140517.GM19507@zod.bos.redhat.com> <1334758134.8818.132.camel@novo.hadess.net> <20120418141131.GN19507@zod.bos.redhat.com> <20120418142450.GA30083@srcf.ucam.org>
In-Reply-To: <20120418142450.GA30083@srcf.ucam.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 07:24 AM, Matthew Garrett wrote:
> On Wed, Apr 18, 2012 at 10:11:31AM -0400, Josh Boyer wrote:
>> On Wed, Apr 18, 2012 at 03:08:54PM +0100, Bastien Nocera wrote:
>>> Don't. The only bit of user-space that's broken is upower, and it's
>>> getting a fixed release shortly.
>> Matthew suggested that additional kernel patches were required to add a
>> scope parameter so upower could understand that the battery is powering
>> a device and not the system.
>>
>> Also, when did it become OK to force-enable a new feature that is
>> _known_ to not work properly on recent userspace?  That makes no sense
>> to me.
> I agree. It's a great feature, but it shouldn't be default y if 
> userspace isn't ready for it yet.

Dammit, I should have pushed harder to get the scope into the same
release.  Oh well.

Does upower trigger a shutdown/hibernation if *any* power supply is low,
or just if all of them are?  Are the failing cases ones where the BT
keyboard is the only visible power supply?

In any case, no objections to disabling it if its the only way to
prevent regressions for now.

    J
