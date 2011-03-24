Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1CXNky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:40:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46938 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1CXNkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i+OcjfO4JXIzK5gIC/YnRDIxyN+0N+yMvkUVU+XDF+MGIicbTneBZmnnzRcCEM9Mlp
         cloxGc45bak88eq6H39zoqbybz/JJ3NE168YDG+gzJID8jbP8e7+8DP89F3AVR4Yry5/
         wn/5tcaJ0DZ+R82+BNEl5SpZRXcGqgJOJ7w0U=
MIME-Version: 1.0
In-Reply-To: <AANLkTikrX_wypmrd-PbST603jsHqkuwtA6t5X65Lg1+O@mail.gmail.com>
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
	<AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
	<20110324131414.GA20612@thinkpad-t410>
	<AANLkTikrX_wypmrd-PbST603jsHqkuwtA6t5X65Lg1+O@mail.gmail.com>
Date: Thu, 24 Mar 2011 13:40:51 +0000
Message-ID: <AANLkTi=2OKxvHN75PO4RGb9rtpnA0iGHNb9JPZwb0z9J@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
From: Corentin Chary <corentin.chary@gmail.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would suggest sending BTN_HOME upon button release 0xe5 (not press
> 0xe4 and do the autorelease because of it) and BTN_PROG2 on
> press-and-hold 0xea.
>
> If you press-and-hold, does it still send the 0xe5 upon release?  That
> could complicate things so that both button events do not get sent.
>
> I'm not sure what BTN_HOME is commonly used for.  This button does
> sound like a HOME button in iPad sense but not in web browser sense.

Except the fact that I don't find BTN_HOME in inpout.h, that's seems a
better idea, forget what I've said earlier.

0xe4 -> KEY_IGNORE
0xe5 -> KEY_HOME
0xea -> KEY_PROG2, (or BTN_TASK to copy android/iOS ?)

-- 
Corentin Chary
http://xf.iksaif.net
