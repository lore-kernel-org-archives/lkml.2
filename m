Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0JANsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:48:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17197 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab0JANsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:48:31 -0400
Date: Fri, 1 Oct 2010 15:47:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c fixes for 2.6.36
Message-ID: <20101001154757.25728340@endymion.delvare>
In-Reply-To: <AANLkTi=aKWP3_KhD88ebGB04xAM9Pc7eqw1LBr2EJNS_@mail.gmail.com>
References: <20101001140619.28d96040@endymion.delvare>
	<AANLkTi=aKWP3_KhD88ebGB04xAM9Pc7eqw1LBr2EJNS_@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 22:38:46 +0900, Kyungmin Park wrote:
> Hi Jean,
> 
> Even though it's not yet acked from Ben. It should be fixed for
> correct operation.
> Without this patch, some I2C device doesn't work correctly.
> http://www.spinics.net/lists/linux-i2c/msg04016.html

This is part of Ben's pull request, not mine. They are completely
independent.

-- 
Jean Delvare
