Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0JELt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:49:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37742 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab0JELtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:49:25 -0400
Date: Tue, 5 Oct 2010 14:48:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "zmc@lurian.net" <zmc@lurian.net>,
        "a.j.buxton@gmail.com" <a.j.buxton@gmail.com>
Subject: Re: [PATCH 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
Message-ID: <20101005114839.GC2977@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <131d16236d19895323fca2f058d65f1f116bacad.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <20101005093206.GB2977@legolas.emea.dhcp.ti.com>
 <1286272519.24366.33.camel@ekuznets-lx-nokia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1286272519.24366.33.camel@ekuznets-lx-nokia>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(don't top post)

On Tue, Oct 05, 2010 at 04:55:19AM -0500, Evgeny Kuznetsov wrote:
>Yes, but no log in that case.

what do you call the stack dump BUG() shows ??

-- 
balbi
