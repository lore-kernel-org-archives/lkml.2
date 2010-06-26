Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0FZIDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 04:03:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:34596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab0FZIDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 04:03:46 -0400
Message-ID: <4C25B45C.9080805@kernel.org>
Date: Sat, 26 Jun 2010 10:03:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org> <4C224502.2040206@kernel.org> <4C2305A8.4070708@odi.ch> <4C24C903.1070705@kernel.org> <4C24EED2.4020300@odi.ch> <4C257CEE.2070309@gmail.com>
In-Reply-To: <4C257CEE.2070309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Jun 2010 08:03:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/26/2010 06:07 AM, Robert Hancock wrote:
> Ahh, ok, it's not sata_nv at all then, it's pata_amd. On the same chip,
> totally different controller though.
> 
> PATA doesn't normally use hard-resets as a means of error recovery -
> that would mean hitting the RESET line, which I don't think most
> controllers can do on software command (it usually only gets asserted on
> power up or hitting the reset button), unlike on SATA where there's a
> defined way to trigger a COMRESET which is mostly equivalent. Also, that
> resets both devices on the channel, unlike soft reset which is specific
> to one device.

Yeah, if it's pata_amd and SRST isn't recovering the device, there
isn't much else to do.  :-(

Thanks.

-- 
tejun
