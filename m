Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0HZRyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:54:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52354 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0HZRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:54:47 -0400
Date: Thu, 26 Aug 2010 18:54:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [2.6.36-rc2] hp-wmi: probe of hp-wmi failed with
	error -22
Message-ID: <20100826175442.GA16305@srcf.ucam.org>
References: <201008261949.12608.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008261949.12608.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 07:49:12PM +0200, Maciej Rutecki wrote:
> Last known good kernel: 2.6.35
> Failing kernel: 2.6.36-rc1, 2.6.36-rc2
> 
> Dmesg says:
> root@gumis:/home/maciek# dmesg | grep -i hp-wmi
> [    5.489731] hp-wmi: probe of hp-wmi failed with error -22

Should be fixed by a8ec105c0764c848d59f18a31f91fa00c99b2e7f

-- 
Matthew Garrett | mjg59@srcf.ucam.org
