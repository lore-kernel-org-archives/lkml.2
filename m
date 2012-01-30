Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2A3RP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:15:57 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44406 "HELO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753694Ab2A3RPz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:15:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAMP44s0YapTKw6tbz3mnYeBXu1Ut-fPahRNy8U3uSroo_zDWtA@mail.gmail.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
	<fd9de2a6c650eb4f5cf611ccd7775b6abb73ac35.1327348286.git.vjaquez@igalia.com>
	<CAMP44s0YapTKw6tbz3mnYeBXu1Ut-fPahRNy8U3uSroo_zDWtA@mail.gmail.com>
Date: Mon, 30 Jan 2012 11:15:42 -0600
Message-ID: <CAB-zwWjit=Qpt3PCW4fS0OEL_hw6=nLO0a9bemzj8eAEOFGBxw@mail.gmail.com>
Subject: Re: [PATCH 2/5] staging: tidspbridge: remove unused header
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: =?ISO-8859-1?Q?V=EDctor_Manuel_J=E1quez_Leal?= <vjaquez@igalia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/24 Felipe Contreras <felipe.contreras@gmail.com>:
> 2012/1/23 Víctor Manuel Jáquez Leal <vjaquez@igalia.com>:
>> No functional changes.
>>
>> The header file drv_interface.h was only used locally, hence there's no need
>> to have it.
>>
>> Also the only prototyped functions were the file_operations callbacks, then
>> this commit moves them up to avoid prototyping too.
...
>
> But looks good to me either way.

FWIW, I agree.

Regards,

Omar
