Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1DGPLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:11:41 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:33236 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279Ab1DGPLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:11:40 -0400
Date: Thu, 7 Apr 2011 17:11:29 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc1 noveau trouble and regression (bad commit:
 38f1cff0863809587b5fd10ecd0c24c8b543a48c )
Message-ID: <20110407151129.GA24977@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	airlied@redhat.com, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110403181206.GA19291@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403181206.GA19291@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

still no joy with 2.6.39-rc2.

Best,
	Dominik

On Sun, Apr 03, 2011 at 08:12:06PM +0200, Dominik Brodowski wrote:
> Hey,
> 
> After bisecting for a day, I'm pretty confident that the commit
> 38f1cff0863809587b5fd10ecd0c24c8b543a48c introduced an error which
> causes one of my computers to hang during boot -- only a blank
> screen appears. The initramfs never gets run.
> 
> The system consists of an Atom D525 with Intel NM10 + NVIDIA GT218/ION2
> chipset.
> 
> Best,
> 	Dominik
