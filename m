Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1FIV2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:28:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33099 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab1FIV23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UzrETZ3mrB2d7tHPnbt6Y/iwVCwpoa7PSoeghc47Jm8RBzZf0N1ZQPr0gWw8v8pHxj
         hghOV09aUOCwK/Y0CbC33SJ65oFBX3nB5tFkrMSxTZbyHhJLYny1hD8kM9EPKX4mbw1g
         nDKv1kNU6oWFbAf1mFKnTcnToyXpt2WO2c2Bc=
Message-ID: <4DF13AF9.4010406@garzik.org>
Date: Thu, 09 Jun 2011 17:28:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marc Giger <gigerstyle@gmx.ch>
CC: linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Disabling SATA Link Power Management (LPM) in GRUB
References: <20110608224527.21d2d911@mgi.gigerstyle.ch>
In-Reply-To: <20110608224527.21d2d911@mgi.gigerstyle.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 04:45 PM, Marc Giger wrote:
> Dear Kernel Devs,
>
> I spent my Samsung RF511 Notebook a OCZ Vertex III SSD. Unfortunately
> there seems to be an incompatibility between these. Samsung is not
> willing to help me, because they won't support foreign Hard- (OCZ SSD)
> and Software (Linux).
>
> I've found the following forum entries which I think is the problem.
>
> http://www.ocztechnologyforum.com/forum/showthread.php?88340-Vertex-3-Windows-install-in-AHCI-mode-on-Intel-6-series-Chipset-platforms
>
> http://www.ocztechnologyforum.com/forum/showthread.php?88630-Vertex-3-problem-booting-windows-7-with-HM65-Sandybride-chips-%28Laptops%29/page3

These are definitely useful data points.  CC'ing linux-ide.

	Jeff


