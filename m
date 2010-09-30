Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0I3BSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:18:21 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39460 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0I3BSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AV+LzeiuIZ1eW+4UqSeePDNNJL8V27EMr90caKQ/x7/fg5f4fAT+XvGGClXEGibxil
         gcQBPFNJuvOjrXgjJ/qYaJy1ugy4hSzoMcNZVaTx79CgN3Usq00k6F338K/t8NNhPmFD
         iQE3A1ML9gshjxQYT/ErNkDsdTDnUoIydgTog=
Date: Wed, 29 Sep 2010 18:18:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: nm127@freemail.hu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: gameport: emu10k1-gp: call pci_disable_device in
 error path and in remove()
Message-ID: <20100930011813.GB5260@core.coreip.homeip.net>
References: <1285503285-6219-1-git-send-email-rahul.ruikar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285503285-6219-1-git-send-email-rahul.ruikar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 05:44:45PM +0530, Rahul Ruikar wrote:
> pci_disable_device() is called for following 2 cases
> - error path in emu_probe()
> - in emu_remove()
> 
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>

Applied, thanks Rahul.

-- 
Dmitry
