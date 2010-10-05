Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0JEJc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:32:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42330 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab0JEJc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:32:27 -0400
Date: Tue, 5 Oct 2010 12:32:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "zmc@lurian.net" <zmc@lurian.net>,
        "a.j.buxton@gmail.com" <a.j.buxton@gmail.com>
Subject: Re: [PATCH 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
Message-ID: <20101005093206.GB2977@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <131d16236d19895323fca2f058d65f1f116bacad.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <131d16236d19895323fca2f058d65f1f116bacad.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 05, 2010 at 03:42:10AM -0500, Evgeny Kuznetsov wrote:
>+	if (!isr_reg) {
>+		printk(KERN_ERR "FATAL: Incorrect GPIO method %i\n",
>+				bank->method);
>+		BUG();
>+		}

this could be simply:

BUG_ON(!isr_reg);

-- 
balbi
