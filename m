Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0CZT4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:56:16 -0400
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:40962
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0CZT4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:56:14 -0400
From: Arnout Vandecappelle <arnout@mind.be>
Organization: Essensium/Mind
To: =?iso-8859-1?q?=C1kos_Mar=F3y?= <akos@maroy.hu>
Subject: Re: how to debug a kernel that does not power off?
Date: Fri, 26 Mar 2010 20:56:10 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.31-14-generic; KDE/4.4.1; x86_64; ; )
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <4BA9525E.9000701@maroy.hu>
In-Reply-To: <4BA9525E.9000701@maroy.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201003262056.11231.arnout@mind.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Take a look at the pm_power_off functions in arch/x86/kernel/apm_32.c

 Regards,
 Arnout

On Wednesday 24 March 2010 00:44:30, Ákos Maróy wrote:
> Hi,
> 
> This might be a lame question, but: how would I debug a kernel that
> simply does not power off a machine? When powering off, on the console I
> get to the message: [...] Poweroff.
> 
> but then, the machine actually does not power off. This is an HP Envy 15
> laptop using an intel i7 CPU, and kernel 2.6.32.9.
> 
> I tried to read up on all sorts of documentation, but could not get more
> debug info out of the kernel :(
> 
> any pointers would be welcome..
> 
> 
> Akos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Arnout Vandecappelle                               arnout at mind be
Senior Embedded Software Architect                 +32-16-286540
Essensium/Mind                                     http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium                BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint:  31BB CF53 8660 6F88 345D  54CC A836 5879 20D7 CF43
