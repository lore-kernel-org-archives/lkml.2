Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967909Ab2ERJgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:36:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52895 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967117Ab2ERJgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:36:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 1/2] gpio: Adjust of_xlate API to support multiple GPIO chips
Date: Fri, 18 May 2012 09:36:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
References: <1337329192-5699-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1337329192-5699-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205180936.45449.arnd@arndb.de>
X-Provags-ID: V02:K0:yk22719IWIgFzZcZyeWi9fgt0TXw99Nr2gvqpskvnTC
 EwMrJSD9f44dMcJ6FlicofMzAUZUQSH2+EOIBMvvsW1bvg5Ao7
 v2bR/zsy4fnIsV/JRMjqo6NVgNOhMsb3Aa+hPvg0J4mZnCiJIB
 u+eErE2NOy3r1Gn2kN3kZ6RA+NQ4BOF9lLXRHjOLmLKTqPJUXn
 8zZApiZ3s5DIUEwZrn5y4gupJBXgbDrSDZYkn4eqaieUiJFQPt
 MGn3nx36cqqWr0sXtjMjSd7+M/c8kt1rRitbKIRqfXhkRhldbJ
 OHbuo25YxQjA7lqFBxgGpB7GVv0UQQf+8B0xaJe+LKAG75xXnX
 Hvs2rYYgf/I5tctVCTyI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2012, Roland Stigge wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> This patch changes the of_xlate API to make it possible for multiple
> gpio_chips to refer to the same device tree node.  This is useful for
> banked GPIO controllers that use multiple gpio_chips for a single
> device.  With this change the core code will try calling of_xlate on
> each gpio_chip that references the device_node and will return the
> gpio number for the first one to return 'true'.
> 
> Cc: Roland Stigge <stigge@antcom.de>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Tested-by: Roland Stigge <stigge@antcom.de>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
