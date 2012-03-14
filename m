Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2CNWdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:33:42 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40168 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759929Ab2CNWdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:33:36 -0400
Date: Wed, 14 Mar 2012 23:33:09 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Add a sysfs node to test the EDAC error report
 facility
Message-ID: <20120314223309.GB27602@aftab>
References: <1331122101-28382-1-git-send-email-mchehab@redhat.com>
 <20120313233138.GA31106@kroah.com>
 <4F60F0D7.70505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F60F0D7.70505@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:26:15PM -0300, Mauro Carvalho Chehab wrote:
> > Then please move it to debugfs, where debugging stuff belongs.
> 
> There are other edac error injection tools at sysfs. That's why I opted to keep
> it there - plus, I was too lazy[1] to learn about the debugfs bits at the time I
> wrote it, and adding a single node to sysfs were very trivial ;)

I have to agree with Greg here, all debug-related stuff (error injection
being somewhat related) should go to debugfs.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
