Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2DRW4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:56:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2DRWzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:55:44 -0400
Date: Wed, 18 Apr 2012 15:55:40 -0700
From: Greg K H <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] edac: move documentation ABI to
 ABI/testing/sysfs-devices-edac
Message-ID: <20120418225540.GA27508@kroah.com>
References: <1334672580-12883-1-git-send-email-mchehab@redhat.com>
 <1334672580-12883-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334672580-12883-2-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:22:59AM -0300, Mauro Carvalho Chehab wrote:
> The EDAC MC API is currently stored at the wrong place. Move the
> parts of the EDAC MC ABI that will be kept to
> ABI/testing/sysfs-devices-edac.
> 
> The Date: field were added based on git timestamps for the git
> commit patches that added the functionality at edac.txt.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

