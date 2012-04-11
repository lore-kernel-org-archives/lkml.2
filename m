Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab2DKTvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:51:10 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45248 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab2DKTvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:51:09 -0400
Date: Wed, 11 Apr 2012 21:50:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Dave Jones <davej@redhat.com>, borislav.petkov@amd.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: microcode driver sysfs warning since 3.3
Message-ID: <20120411195056.GC18114@aftab>
References: <20120411191527.GA24468@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411191527.GA24468@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 03:15:27PM -0400, Dave Jones wrote:
> We've had a number of users report the following trace recently..
> 
> backtrace:
> :WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xfa/0x100()
> :Hardware name:

Yep, we saw it too. Working on it:

http://marc.info/?l=linux-kernel&m=133416410407131

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
