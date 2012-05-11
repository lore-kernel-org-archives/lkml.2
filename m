Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab2EKKJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:09:09 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:32880 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2EKKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:09:07 -0400
Date: Fri, 11 May 2012 12:08:52 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Increase version to 3.0.0 (aka: "HERM" version)
Message-ID: <20120511100852.GH8913@aftab.osrc.amd.com>
References: <4FABDBE6.3060901@redhat.com>
 <1336679860-5340-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336679860-5340-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 04:57:40PM -0300, Mauro Carvalho Chehab wrote:
> There were lots of changes introduced to justify renaming it to
> 3.0.0 (HERM - Hardware Events Report Method):
> 
>   - EDAC core were redesigned to represent all types of
>     memory controllers;
> 
>   - EDAC API were redesigned to properly represent the memory
>     controller hierarchy;
> 
>   - a tracepoint-based API were added to report memory errors.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Dude, drop this goddam "HERM" thing already! Just call EDAC 3.0.0 and
stop mentioning HERM anywhere - use it in your own paper jumble if it
helps you but don't leak it into the kernel.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
