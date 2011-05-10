Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1EJGkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 02:40:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34821 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1EJGke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 02:40:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=faAmdIgrS+C4HhuaO+/pbN0HDLJaGAX1f3bv6TG/6tnLhEUiHo3Nk9lM/0ZH/+0j12
         Xi1WVucxqzUDhXyF9w/CqL0KU6TRyMrqYZ6WZ71Xa25p8KQdzzXJTr4PcfJ3jpeSMNZT
         oG1w4RTbU31cRlrzvm8pwJamZuIfweaffEMUE=
MIME-Version: 1.0
In-Reply-To: <20110509185727.GA9811@srcf.ucam.org>
References: <20110509185727.GA9811@srcf.ucam.org>
Date: Tue, 10 May 2011 08:40:32 +0200
Message-ID: <BANLkTim-momwpCCwZtL8sQyCmUvQ_Fz8Gw@mail.gmail.com>
Subject: Re: [GIT PULL] x86 platform driver updates
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the rfkill code on
> the Eee is currently completely broken for PCIe systems that don't put
> devices on bus 0.

> Matthew Garrett (1):
>      eeepc-laptop: Use ACPI handle to identify rfkill port

Hi Matthew,
Thanks for fixing that.
Should this also go to stable ?
If you have the hardware, could you also fix asus-wmi (1000H is the
only eeepc known to use both hotplug and eeepc) ?
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
