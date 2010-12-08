Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0LHT3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:29:35 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:33761 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab0LHT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:29:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QfIiO6AnRVpUh6AFv36Y3QjFRJRZHd/fo+9qAa/EEvxUaVZ5WdQm4fhGbg8nAxj8Mz
         s5fFnd07PDuD2VJ23ZFbVEuOcU8YI0sQmKibi+UoRCHnIzwk+PgY9KqAr/MjtWmLYX/K
         tcqysp2diee7PlftogQ0C5EKggJhHyw3Y3+jg=
Subject: Re: [PATCH v2] mach-at91: Support for gms board added
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@maxim.org.za,
        linux@arm.linux.org.uk, costa.antonior@gmail.com
In-Reply-To: <20101208140313.GD3429@game.jcrosoft.org>
References: <1291732927-9429-1-git-send-email-plyatov@gmail.com>
	 <4CFE90CA.9050004@bluewatersys.com> <4CFF47A0.8010208@atmel.com>
	 <20101208140313.GD3429@game.jcrosoft.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 22:29:28 +0300
Message-ID: <1291836568.15873.58.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean-Christophe,

> > I have exactly the same feeling as Ryan. We should make sure 
> > to factorize as much code as possible for maintenance reasons.
> > 
> > If you need to distinguish between board features, you can 
> > pass information in system_rev as implemented in this 
> > board merging commit:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6e016f19d393fbe4e040bee8155b03b840fa689
> I agree with nico not need to have a new board for just few difference
> 
> and as we start with the rm9200 we will reduce the number of defconfig first per soc and then for the all sam9

I think it does not make sence to invent new machine for each new
carrier board. Better to have a kernel configuration options which will
allow to select required carrier board.

Best regards!
--
Igor Plyatov

