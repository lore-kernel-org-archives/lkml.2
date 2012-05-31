Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab2EaPl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:41:58 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43388 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2EaPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:41:57 -0400
Date: Thu, 31 May 2012 17:42:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: CROSS_MEMORY_ATTACH default y?
Message-ID: <20120531154224.GL14515@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531153512.GK14515@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ LKML.

On Thu, May 31, 2012 at 05:35:12PM +0200, Borislav Petkov wrote:
> Hi,
> 
> can you please explain why CROSS_MEMORY_ATTACH is default y? Why should
> those process_vm_{readv,writev} syscalls be enabled by default?
> 
> Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
