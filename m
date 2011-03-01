Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1CAD3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 22:29:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43190 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab1CAD3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 22:29:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=jkB65TasIoad1iLXIoPfHOQvLdJ7mV/irWKFcvNftMfDTRumQec2CZYUe9XcfFqan9
         zPddFUtFlkjtEpUViv+Q3/C1ouazIOpfcILOpWMmDCM/Hs7yhwLeLqsxEpZdkTjuHkV8
         XR3awE2K8DN2b+fBsZV3iXctXbNOZU3su7W6Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTinV+bnSBe+5CSuYYCU4gCq9Z2c9ELdy-LFAvdf0@mail.gmail.com>
References: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com>
 <AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
 <20110225071827.GA14053@core.coreip.homeip.net> <AANLkTinV+bnSBe+5CSuYYCU4gCq9Z2c9ELdy-LFAvdf0@mail.gmail.com>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <keng-yu.lin@canonical.com>
Date: Tue, 1 Mar 2011 11:29:15 +0800
X-Google-Sender-Auth: Y7sjBqBdmPTpcV6P1CUUOk2CTsw
Message-ID: <AANLkTi=GFz4i1Y7ok=2Zt9ApbeAc4zN4tbaKppqB_LGA@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: set the touchpad toggle key code to F21
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        tyson.chen@canonical.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:14 PM, Chris Bagwell <chris@cnpbagwell.com> wrote:
>
> I submitted last month a patch to udev to do the scancode-to-F21
> mapping.  So that part should be covered for near term.
>
> I also agree if we are going to change kernel side, we should change
> to KEY_TOUCHPAD_TOGGLE in both eeepc-laptop and eeepc-wmi.
>
> http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=0d8b6be5f5238360d2d8e220d6da280f842c5358
>
> Chris
>

Thanks Chris for the information. I also tested; it works.

I will re-send a eeepc-wmi patch with KEY_TOUCHPAD_TOGGLE.
