Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1IBQii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:38:38 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:42569 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1IBQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:38:37 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll3c7qFNVV
X-RZG-CLASS-ID: mo00
Date: Fri, 2 Sep 2011 18:38:20 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Greg KH <gregkh@suse.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH] Staging: hv: vmbus: Show the modalias in
 /sys/bus/vmbus/devices/*/
Message-ID: <20110902163820.GA25353@aepfle.de>
References: <20110902162556.GA25073@aepfle.de>
 <20110902163550.GA5508@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110902163550.GA5508@suse.de>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, Greg KH wrote:

> On Fri, Sep 02, 2011 at 06:25:56PM +0200, Olaf Hering wrote:

> > +#define VMBUS_ALIAS_LEN ((sizeof((struct hv_vmbus_device_id *)0)->guid) * 2)

> > +	char alias_name[VMBUS_ALIAS_LEN + 1];
> 
> Is that too big to put on the stack?  64 bytes, right?  Hm, maybe not.

16 * 2 + 1 = 33 bytes.

Olaf
