Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1JVEMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 00:12:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44493 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1JVEM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 00:12:28 -0400
Message-ID: <4EA242A9.3060300@pobox.com>
Date: Sat, 22 Oct 2011 00:12:25 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Paul Schilling <paul.s.schilling@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/14] ATA : vortex86 : fix vortex86dx/sx hardware CRC
 bug.
References: <Vortex86_PATA> <1319254458-4692-1-git-send-email-paul.s.schilling@gmail.com>
In-Reply-To: <1319254458-4692-1-git-send-email-paul.s.schilling@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2011 11:34 PM, Paul Schilling wrote:
> This fixes a DMA issue related to a CRC bug on
> the RDC pata peripherial found on the vortex86sx and vortex86dx.
>
> Signed-off-by: Paul Schilling<paul.s.schilling@gmail.com>

I'm sorry, this is not acceptable.

You missed in hundreds of lines of useless reformatting in amongst the 
fixes.

Please separate out logical changes - thus, any whitespace/reformatting 
must be in a separate patch from your fixes.



