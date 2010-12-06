Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0LFNDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:03:48 -0500
Received: from mxs.selfmail.ru ([77.221.143.26]:57345 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751254Ab0LFNDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:03:47 -0500
X-ACL-SPF: 
Subject: Re: [Xen-devel] [PATCH 0/2] Xen PV on HVM multiple PV consoles
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <alpine.DEB.2.00.1012061035070.9029@kaball-desktop>
References: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>
	 <1291236234.22027.0.camel@mobile>
	 <alpine.DEB.2.00.1012021720170.14723@kaball-desktop>
	 <1291404900.5298.15.camel@mobile>
	 <alpine.DEB.2.00.1012061035070.9029@kaball-desktop>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Mon, 06 Dec 2010 16:03:34 +0300
Message-ID: <1291640614.32324.85.camel@work.selfip.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 10:36 +0000, Stefano Stabellini wrote:

> 
> Could you please add CONFIG_DEBUG_INFO=y to your kernel config, so that
> we can see the name of the functions in the stack trace?
> 

After add debug kernel not crushed. I'm test more expensive it now. Can
You provide ps auxwww | grep qemu-dm after creating domain with two
serial consoles? (sles does not have libxl, i want to write now wrapper
to qemu-dm, after that try to compile rpm from spec to support libxl).



-- 
Vasiliy G Tolstov <v.tolstov@selfip.ru>
Selfip.Ru

