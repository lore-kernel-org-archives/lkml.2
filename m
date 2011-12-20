Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1LTXu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:50:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63877 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1LTXuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:50:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111221004352.39dbb43a@stein>
References: <20111220213017.75ff380c@stein> <20111220213120.5e275f10@stein>
 <CADmzSSjfFgrAroh8jZfC-q0dNuDgsyoNcUfTik6gBx75zrngFw@mail.gmail.com>
 <20111221001031.539ef397@stein> <20111221004352.39dbb43a@stein>
From: Carl Karsten <carl@personnelware.com>
Date: Tue, 20 Dec 2011 17:50:02 -0600
X-Google-Sender-Auth: QanArOc7tOFUfVKIePWVsXhyhiQ
Message-ID: <CADmzSShVE9PNc+imVakhDfp-+nfga59kbKczAgKomiu94ayn8g@mail.gmail.com>
Subject: Re: [PATCH 1/3] firewire: do not expose globally unique IDs in the
 kernel log
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 5:43 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Dec 21 Stefan Richter wrote:
>> Or you run "grep . /sys/bus/firewire/devices/*/guid | sed s/\\/guid:/\\t/"
>> before dvgrab, and you get a list of GUIDs from which you can copy and
>> paste.
>
> Or
>        (cd /sys/bus/firewire/devices; grep . $(ls -c */guid)) | sed s/\\/guid:/\\t/
>
> for a list in reverse-chronological order of discovery.
> Same but narrowed down to AV/C devices:
>
>        (cd /sys/bus/firewire/devices; for fw in $(grep 0x00a02d:0x010001 $(ls -c */units) | cut -f1 -d/); do printf $fw\\t; cat $fw/guid; done)

To further describe my pain: I am going to run dmesg anyway to see if
the device is being detected and or any errors.  Once I see that it is
connected, it is really nice having the guid right there.

I am really bummed I didn't invite you to PyCon in Leipzig so you
could see what I do first hand.    Maybe next time.

-- 
Carl K
