Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2BVTY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:24:28 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40882 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2BVTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:24:27 -0500
Message-ID: <4F4540E6.2020708@suse.cz>
Date: Wed, 22 Feb 2012 20:24:22 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: stable <stable@kernel.org>
CC: mjg@redhat.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        "jirisl >> Jiri Slaby" <jirislaby@gmail.com>
Subject: Lost ps/2 input in 3.2.5 (aka PCI: Rework ASPM disable code)
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so I finally decided to commit 3.2.5 into the opensuse kernel. However
it does not even work on my laptop.

Both keyboard and touchpad are not detected. They are connected via PS/2.

I see
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
boot with i8042.nopnp

Without that patch this warning is gone and devices properly enumerated.

thanks,
-- 
js
suse labs
