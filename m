Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1FPP5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:57:33 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:42487 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754314Ab1FPP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:57:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XO0lqFoVM1lK0LYJC2y4D67Y.dvV6CLRh3v427algxj3piZ
 DENJaIAaM2tfDONJmsw8JEcT3T7lGV2Xyb95D8jiv9i3kUBd7AUh8lavatGb
 DoWAPwqqGOKRHF8PCUYJen_wYBaDNQct._YS_15Wl8T9ZsOkBT1RzkvRdjKu
 DUfuTVXRkRGzMf10G0VspmqsrDVHrr1ZUSf_NoEOyrOk9hEETvOzBC.Bu_hJ
 71Ek1bP8OdZncE5HXnyXuYJNJMRNDrCNqP9nIetww3vb5Y3crZW3Gl_AXO2P
 sWRZzO2cv8fPWhlhl9KMaBiPhfRgDKye.4qPub6Bj7grCIofB
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 16 Jun 2011 10:57:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rik van Riel <riel@redhat.com>
cc: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyle McMartin <kyle@redhat.com>
Subject: Re: SLUB BUG: check_slab called with interrupts enabled
In-Reply-To: <4DF9F84B.7040007@redhat.com>
Message-ID: <alpine.DEB.2.00.1106161056450.3738@router.home>
References: <4DF8C80F.7090403@redhat.com> <alpine.DEB.2.00.1106150959500.768@router.home> <4DF8CCE1.80400@redhat.com> <alpine.DEB.2.00.1106151040020.768@router.home> <4DF9F84B.7040007@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Rik van Riel wrote:

> After backing them out, I got 18 hours of uptime so far.
>
> This could just be dumb luck, or it could be some slub vs. kswapd
> interaction.  Or maybe I simply am not triggering the original
> bug any more because kswapd is now doing all the work, but may
> still be able to trigger it under more memory pressure...

Could be some memory issue or stack corruption. This is a machine with ECC
ram right?

> Either way, since this could still be dumb luck, I'll let you
> guys know if/when I see a next crash :)

OK.

