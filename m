Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2BFRem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:34:42 -0500
Received: from claw.goop.org ([74.207.240.146]:46545 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2BFRel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:34:41 -0500
Message-ID: <4F300F2C.9030308@goop.org>
Date: Mon, 06 Feb 2012 09:34:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Przemo Firszt <przemo@firszt.eu>, chris@cnpbagwell.com,
        pinglinux@gmail.com, linuxwacom-devel@lists.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Fix invalid power_supply_powers calls
References: <1328481324-7241-1-git-send-email-przemo@firszt.eu>    <alpine.LNX.2.00.1202061326150.24127@pobox.suse.cz> <d2139519eb66f9b7bfd8f56d3b4e2d96.squirrel@webmail.firszt.eu> <alpine.LNX.2.00.1202061342090.24127@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1202061342090.24127@pobox.suse.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 04:42 AM, Jiri Kosina wrote:
> On Mon, 6 Feb 2012, przemo@firszt.eu wrote:
>
>>> Hmm, seems valid. How did you notice? Have you seen crashes because of
>>> wild pointers?
>> Hi Jiri,
>> Yes, the driver was unusable - 100% crashes during connection.
> Okay, I thought that'd be the case.

Very sorry about that.  I don't have a device to test with, so I should
have reviewed the code extra carefully.

Does the same bug apply to the Wii changes, which were of the same form?

    J
