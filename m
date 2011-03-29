Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1C2Kb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:31:59 -0400
Received: from 82-148-208-25.fiber.unet.nl ([82.148.208.25]:36182 "EHLO
	berilia.team-embedded.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752431Ab1C2Kb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:31:57 -0400
X-Greylist: delayed 2596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Mar 2011 06:31:57 EDT
Subject: Re: [uClinux-dev] [PATCH] NOMMU: implement access_remote_vm
From: "Ithamar R. Adema" <ithamar.adema@team-embedded.nl>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
        Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
In-Reply-To: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
References: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 11:48:26 +0200
Message-ID: <1301392106.2060.12.camel@team-embedded-2>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 16:32 -0400, Mike Frysinger wrote:
> Recent vm changes brought in a new function which the core procfs code
> utilizes.  So implement it for nommu systems too to avoid link failures.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

This patch fixes the problem for my NXP lpc2k ARM7TDMI architecture that
I'm mainlining currently, so you can add my:

Tested-by: Ithamar Adema <ithamar.adema@team-embedded.nl>

Regards,

Ithamar.


