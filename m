Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0KKAgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:36:22 -0500
Received: from kroah.org ([198.145.64.141]:57981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417Ab0KKAgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:36:20 -0500
Date: Wed, 10 Nov 2010 16:26:51 -0800
From: Greg KH <greg@kroah.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: ft1000: Remove unused char dev inerface.
Message-ID: <20101111002651.GA21632@kroah.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
 <1289384128-19823-2-git-send-email-marek.belisko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289384128-19823-2-git-send-email-marek.belisko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:15:27AM +0100, Marek Belisko wrote:
> This patch remove lot of code for character device. This
> interface was used for getting network informations and
> statistics which is currently exported via /proc filesystem.
> 
> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>

This patch does not apply :(

thanks,

greg k-h
