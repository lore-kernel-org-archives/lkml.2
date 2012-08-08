Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2HHJMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964912Ab2HHJMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:12:51 -0400
Date: Wed, 8 Aug 2012 11:12:36 +0200
From: Andrew Jones <drjones@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v8] kvm: notify host when the guest is panicked
Message-ID: <20120808091235.GA2663@turtle.usersys.redhat.com>
References: <5021D235.4050800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5021D235.4050800@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
> diff --git a/Documentation/virtual/kvm/pv_event.txt b/Documentation/virtual/kvm/pv_event.txt
> new file mode 100644
> index 0000000..0ebc890
> --- /dev/null
> +++ b/Documentation/virtual/kvm/pv_event.txt
> @@ -0,0 +1,32 @@
> +The KVM paravirtual event interface
> +=================================
> +
> +Initializing the paravirtual event interface
> +======================
> +kvm_pv_event_init()
> +Argiments:
> +	None
> +
> +Return Value:
> +	0 : The guest kernel can't use paravirtual event interface.
> +	-1: The guest kernel can use paravirtual event interface.
> +

This documentation has the can and can't backwards.
