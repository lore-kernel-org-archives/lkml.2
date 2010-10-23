Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0JWIZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 04:25:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45839 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0JWIZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 04:25:18 -0400
Date: Sat, 23 Oct 2010 10:26:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg KH <greg@kroah.com>
Cc: Borislav Petkov <bp@amd64.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Erratum 383 fix for 32 bit x86 kernels
Message-ID: <20101023082628.GB27125@aftab>
References: <20100924115239.GA9817@amd.com>
 <20100924160205.GB21235@kroah.com>
 <20100924162433.GB7627@aftab>
 <20101022161810.GF18595@kroah.com>
 <20101022162038.GA10343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022162038.GA10343@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 12:20:38PM -0400, Greg KH wrote:
> Oops, nope, that didn't work for the .32 kernel tree.  If you want these
> patches there, please backport them and test them to verify that they
> build and work properly.

I'll try to get to it next week, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
