Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab2AXRpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:45:12 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43679 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167Ab2AXRpJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:45:09 -0500
MIME-Version: 1.0
In-Reply-To: <fd9de2a6c650eb4f5cf611ccd7775b6abb73ac35.1327348286.git.vjaquez@igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
	<fd9de2a6c650eb4f5cf611ccd7775b6abb73ac35.1327348286.git.vjaquez@igalia.com>
Date: Tue, 24 Jan 2012 19:45:08 +0200
Message-ID: <CAMP44s0YapTKw6tbz3mnYeBXu1Ut-fPahRNy8U3uSroo_zDWtA@mail.gmail.com>
Subject: Re: [PATCH 2/5] staging: tidspbridge: remove unused header
From: Felipe Contreras <felipe.contreras@gmail.com>
To: =?UTF-8?Q?V=C3=ADctor_Manuel_J=C3=A1quez_Leal?= 
	<vjaquez@igalia.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/23 Víctor Manuel Jáquez Leal <vjaquez@igalia.com>:
> No functional changes.
>
> The header file drv_interface.h was only used locally, hence there's no need
> to have it.
>
> Also the only prototyped functions were the file_operations callbacks, then
> this commit moves them up to avoid prototyping too.

'Also' is a keyword that usually denotes that we are talking about two
patches here: one that reshuffles the code, and another one that
removes the header.

But looks good to me either way.

-- 
Felipe Contreras
