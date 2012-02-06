Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2BFMfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:35:22 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:35440 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754440Ab2BFMfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:35:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=tfpq7Bgzqdos56+a1cNVygCZixvKx3OMhcoga70J+BgpAEx2Z3A1mcfoex0A1ZVSaSZltGsWs0kpNYRoUTZ128ir0x0BV4f+DeWqK7vHGqhV4/HiMpVZbm+uqHod1yOS;
Message-ID: <d2139519eb66f9b7bfd8f56d3b4e2d96.squirrel@webmail.firszt.eu>
In-Reply-To: <alpine.LNX.2.00.1202061326150.24127@pobox.suse.cz>
References: <1328481324-7241-1-git-send-email-przemo@firszt.eu>
    <alpine.LNX.2.00.1202061326150.24127@pobox.suse.cz>
Date: Mon, 6 Feb 2012 12:34:57 -0000
Subject: Re: [PATCH] HID: wacom: Fix invalid power_supply_powers calls
From: przemo@firszt.eu
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Przemo Firszt" <przemo@firszt.eu>, chris@cnpbagwell.com,
        pinglinux@gmail.com, linuxwacom-devel@lists.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jeremy Fitzhardinge" <jeremy@goop.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 5 Feb 2012, Przemo Firszt wrote:
[..]
> Hmm, seems valid. How did you notice? Have you seen crashes because of
> wild pointers?

Hi Jiri,
Yes, the driver was unusable - 100% crashes during connection.

Chris came up with the solution, I did coding & testing.

The crash details are here:  http://pastebin.com/ZVNZWaPs

regards,
Przemo

