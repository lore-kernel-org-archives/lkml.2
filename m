Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab2FHSbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:31:39 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64300 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2FHSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:31:35 -0400
Message-ID: <4FD24503.7070608@landley.net>
Date: Fri, 08 Jun 2012 13:31:31 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial] Documentation: Fix typo in devicetree/bindings
References: <1339170418-9999-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1339170418-9999-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 10:46 AM, Masanari Iida wrote:
> Correct spelling typo in Documentation/devicetree/bindings
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Rob Landley <rob@landley.net>

Although:

> --- a/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
> +++ b/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
> @@ -1,7 +1,7 @@
>      4xx/Axon EMAC ethernet nodes
>  
>      The EMAC ethernet controller in IBM and AMCC 4xx chips, and also
> -    the Axon bridge.  To operate this needs to interact with a ths
> +    the Axon bridge.  To operate this needs to interact with a this
>      special McMAL DMA controller, and sometimes an RGMII or ZMII
>      interface.  In addition to the nodes and properties described
>      below, the node for the OPB bus on which the EMAC sits must have a

interact with a this special?

Possibly "ths" means something else here?

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
