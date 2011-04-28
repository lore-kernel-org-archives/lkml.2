Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1D1I1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:27:50 -0400
Received: from service87.mimecast.com ([94.185.240.25]:53518 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754618Ab1D1I1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:27:48 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Catalin Marinas <catalin.marinas@arm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <11431.1303949729@localhost>
References: <201104212129.17013.arnd@arndb.de>
	 <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
	 <201104271243.16868.arnd@arndb.de>
	 <1303902508.15101.21.camel@e102109-lin.cambridge.arm.com>
	 <11431.1303949729@localhost>
Organization: ARM Limited
Date: Thu, 28 Apr 2011 09:27:39 +0100
Message-ID: <1303979259.26744.3.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 28 Apr 2011 08:27:40.0230 (UTC) FILETIME=[233FBE60:01CC057E]
X-MC-Unique: 111042809274403501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 01:15 +0100, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 27 Apr 2011 12:08:28 BST, Catalin Marinas said:
> 
> > The current version of the ARM ARM says "unpredictable". But this
> > general definition of "unpredictable" does not allow it to deadlock
> > (hardware) or have security implications. It is however allowed to
> > corrupt data.
> 
> Not allowed to have security implications, but is allowed to corrupt data.

By security I was referring to TrustZone extensions. IOW, unpredictable
in normal (non-secure) world should not cause data corruption in the
secure world.

-- 
Catalin


