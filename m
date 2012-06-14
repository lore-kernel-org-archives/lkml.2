Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2FNTBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:01:11 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41090 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab2FNTBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:01:10 -0400
Date: Thu, 14 Jun 2012 21:01:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, pawel.moll@arm.com,
        jbaron@redhat.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with
 initcall levels
Message-ID: <20120614190130.GC31640@aftab.osrc.amd.com>
References: <20120612105913.GA8404@aftab.osrc.amd.com>
 <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 12:51:02PM -0600, Jim Cromie wrote:
> main.c has initcall_level_names[] for parse_args to print in debug messages,
> add comments to keep them in sync with initcalls defined in init.h.
> Also tweak comment re not using *_initcall macros in loadable modules.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
