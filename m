Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1ECLJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:09:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42335 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1ECLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aoAMLOwS/MI8gHMlGVE7vSVTKlg9SH13OeoLQUBaoEOs9cWFVJKLQJF5dZxIAzXefF
         J0NPw+aE3BXh7YjI/kUS8pPxnm/7ngEmvtGJfMnpHZ6s5hl+BePVZ6YztqptC8w/ej0O
         utFL1FW/xAWL1GRRBPQp3whqJycasf+MAgJro=
MIME-Version: 1.0
In-Reply-To: <20110503100042.GA1762@opensource.wolfsonmicro.com>
References: <1304415149-19725-1-git-send-email-marek.belisko@open-nandra.com>
	<20110503100042.GA1762@opensource.wolfsonmicro.com>
Date: Tue, 3 May 2011 13:09:27 +0200
Message-ID: <BANLkTimE_TEzManZb2McLnohqbc27hRZ=w@mail.gmail.com>
Subject: Re: [PATCH] SOC: UDA134x: Enable POWER_OFF_ON_STANDBY define.
From: Belisko Marek <marek.belisko@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: tiwai@suse.de, perex@perex.cz, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 12:00 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, May 03, 2011 at 11:32:29AM +0200, Marek Belisko wrote:
>> Without this define we can't get any sound from codec so enable
>> it by default. This define unlock bias settings which control
>> power control for DAC and ADC (by default 0 0 which is off off).
>
> If this is essential why is it optional in the first place?
Not sure about background. Maybe whole define should be removed
This change was introduced in commit:f0fba2ad

>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
