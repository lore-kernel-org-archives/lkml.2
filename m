Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0KXPtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:49:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39688 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0KXPtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hE+9c9oI75l4Yq543bZ4ZlnxutNPU3/jGbBnzX+DF9kNWVWQ6FClpErtWMILXEFl22
         NlS8Ghc6mMfJT2qFb6nRByRPgLZLpRiwCrQ2auCG+xTeT9aNgTAIheS16/14yTZl1lO/
         MupejQItWsVWB08ruSfrfWpCL42JE3h+eRe6o=
Message-ID: <4CED33E0.5040000@lwfinger.net>
Date: Wed, 24 Nov 2010 09:48:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Pavel Machek <pma@sysgo.com>
CC: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, rudolf.marek@sysgo.com, cko@sysgo.com,
        mfa@sysgo.com, anl@sysgo.com
Subject: Re: working usb wifi card, that is still possible to buy
References: <20101103092431.GA21138@pma.sysgo.com> <20101124081616.GA30595@pma.sysgo.com> <20101124131320.GA2611@pma.sysgo.com>
In-Reply-To: <20101124131320.GA2611@pma.sysgo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 07:13 AM, Pavel Machek wrote:
> |                                          |              
> | D-Link DWA-131            | 07d1:3303 | realtek?            |                                          |              

This one should work with driver r8712u in staging in kernel 2.6.37-rcX. I don't
have this model for testing, but the DWA-130 is rock solid with that driver.

Larry
