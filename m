Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab2C3PjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:39:18 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44724 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2C3PjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:39:06 -0400
Date: Fri, 30 Mar 2012 17:38:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] edac: Create a dimm struct and move the labels
 into it
Message-ID: <20120330153859.GC30876@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1333039546-5590-2-git-send-email-mchehab@redhat.com>
 <20120330105048.GA30876@aftab>
 <4F75B475.7060608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F75B475.7060608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 10:26:13AM -0300, Mauro Carvalho Chehab wrote:
> > There's a double loop above this one which iterates over the same
> > things: rows and then channels in each row. So merge that loop with the
> > one above instead of repeating it here.
> 
> The first loop will disappear on the patch I'm writing right now with the 
> edac_mc_alloc() changes to per-csrow/per-dimm/per-channel kzalloc().

Nevertheless, please fix it as suggested.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
