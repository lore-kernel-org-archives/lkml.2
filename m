Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2C1BGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 21:06:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:44338 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab2C1BGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 21:06:19 -0400
Message-ID: <1332896771.2882.67.camel@pasglop>
Subject: Re: WARNING: at drivers/gpu/drm/radeon/radeon_object.c:236
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Jones <davej@redhat.com>
Cc: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Wed, 28 Mar 2012 12:06:11 +1100
In-Reply-To: <20120328002127.GA8368@redhat.com>
References: <20120326213250.GA16328@redhat.com>
	 <1332829303.2882.52.camel@pasglop> <1332836421.5395.338.camel@thor.local>
	 <20120328002127.GA8368@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 20:21 -0400, Dave Jones wrote:

> 
> Stops the warning, and there are no additional side-effects,
> so looks all good here.

Same.

> Tested-by: Dave Jones <davej@redhat.com>

Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> thanks,
> 
> 	Dave


