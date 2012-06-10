Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2FJLUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:20:34 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:53588 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387Ab2FJLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:20:33 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2012 07:20:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqB1E9bdWOb/2dsb2JhbABFtFqBB4IYAQEFeAEQCxUDCRYPCQMCAQIBRQcMAQUCAogLt1CLJ4VpA5Uej3uCYg
X-IronPort-AV: E=Sophos;i="4.77,384,1336341600"; 
   d="scan'208";a="918719274"
Message-ID: <4FD4843F.6070602@igalia.com>
Date: Sun, 10 Jun 2012 13:25:51 +0200
From: =?ISO-8859-1?Q?Javier_Mu=F1oz?= <jmunhoz@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, teddy.wang@siliconmotion.com.cn
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: sm7xxfb: sm7xx becomes sm7xxfb
References: <1339326744-17507-1-git-send-email-jmunhoz@igalia.com> <1339326744-17507-4-git-send-email-jmunhoz@igalia.com>
In-Reply-To: <1339326744-17507-4-git-send-email-jmunhoz@igalia.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 01:12 PM, Javier M. Mellid wrote:
> From: "Javier M. Mellid" <jmunhoz@igalia.com>
> 
> Rename sm7xx driver to sm7xxfb. Fix Kconfig and Makefile to fit the new
> change.
> 
> Changes are coherent with the rest of stable framebuffer drivers. TODO
> updated.

Just one doubt. I am using 'git mv' here and it works Ok. 'git log
--follow' would be the way to see the whole history after this commit.
Should I follow another approach? I am using a 'similar approach' to
ed16648eb5b86917f0b90bdcdbc857202da72f90 commit to rename.

Please, let me know if I should redo this patch.

Thanks.

Javier
