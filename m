Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1G0VRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:17:19 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46679 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1G0VRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:17:17 -0400
X-Auth-Info: VOBltCvuxbxf9GSQl+t22kqDzLe4NhY58wlyxkp9CF0=
To: Joe Perches <joe@perches.com>
cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Graeme Russ <graeme.russ@gmail.com>,
        U-Boot Users <u-boot@lists.denx.de>, linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [U-Boot] [RFC PATCH] checkpatch.pl: Add ability to ignore various messages
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8bit
In-reply-to: <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com>
References: <1303713156.1745.38.camel@Joe-Laptop> <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com>
Comments: In-reply-to Joe Perches <joe@perches.com>
   message dated "Mon, 25 Apr 2011 17:43:22 -0700."
Date: Wed, 27 Jul 2011 23:17:07 +0200
Message-Id: <20110727211707.139ED15794C3@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

In message <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com> you wrote:
> Some users would like the ability to not emit some of the
> messages that checkpatch produces.
> 
> Add command line option to "--ignore" various message types.
> Add .checkpatch.conf file to store a default set of "ignore" flags
> Categorize all ERROR, WARN and CHK types with flags.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl |  456 +++++++++++++++++++++++++++++++++++--------------
>  1 files changed, 327 insertions(+), 129 deletions(-)

Did you receive any feedback for your proposal, especially from Andrew
Morton?

This feature would be really useful for us, but I'd rather see this in
mainline than starting a fork.

Best regards,
Viele Grüße,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The IQ of the group is the lowest IQ of a member of the group divided
by the number of people in the group.
