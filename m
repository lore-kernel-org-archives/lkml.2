Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0LFPa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:30:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LFPa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oCGNwpHB9AiWE6dGaboNGK6aErmvoradVwdCOh6rUfFIASwE7TFwywDJLLYTIQaGje
         65kYHJ/zFHQiK2q6j4Gg2RQISCE/GXZ61x2O+NspQx4v4mhb52hRQ0I2zCT17cKfwwFo
         4/RwTFweaH1hW8letPmIbQUwLN3JHkqz5NFc4=
Message-ID: <4CFD019E.6050204@lwfinger.net>
Date: Mon, 06 Dec 2010 09:30:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Pavel Machek <pma@sysgo.com>
CC: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, rudolf.marek@sysgo.com, cko@sysgo.com,
        mfa@sysgo.com, anl@sysgo.com, vojtech@ucw.cz
Subject: Re: working usb wifi card, that is still possible to buy
References: <20101103092431.GA21138@pma.sysgo.com> <20101124081616.GA30595@pma.sysgo.com> <20101124131320.GA2611@pma.sysgo.com> <20101206083718.GA27061@pma.sysgo.com>
In-Reply-To: <20101206083718.GA27061@pma.sysgo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 02:37 AM, Pavel Machek wrote:
> Hi!
> 
> So... these are my results of wifi testing. 802.11n driver currently
> working on powerpc is rtl8712 -- staging -- EMTEC Wi350 ...

Good to hear as I have no big-endian system for tests. Converting that driver to
work with mac80211 is on my todo list.

Larry
