Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab1E0G1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:27:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54640 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1E0G1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GnCFcwWpalqe9chZyDl5IE6Bj30RXWTsHpvgHB60YVLH0ioHPYNkRFBsBVHXsv6NnQ
         rB3UagGEcCWo9fCqIOR9ild3htIZQXSAPoaLJSSWSlLOf5yC3VlDHBhbTY+rvtMgEhBp
         RNkFVo4crOBFhmJMw/NHSi+P1M+2mXVRWsebI=
MIME-Version: 1.0
In-Reply-To: <4DDF23F5.1090206@jp.fujitsu.com>
References: <4DDF21DE.9040705@jp.fujitsu.com>
	<4DDF23F5.1090206@jp.fujitsu.com>
Date: Thu, 26 May 2011 23:27:48 -0700
Message-ID: <BANLkTinCRX3YOXwuphRTBS=OcHuC07a1jw@mail.gmail.com>
Subject: Re: [PATCH 07/12] x86, mce: introduce mce_gather_info()
From: Tony Luck <tony.luck@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/26 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:

> As the result the mce_get_rip() is integrated and unnecessary
> zero-ing is removed.  This also fix an issue pointed by Tony Luck
> that RIP is required to make some decision about error severity
> (for SRAR errors) but it was retrieved later in the handler.

To keep the credit path accurate, that was one of the pieces I picked
up from Andi.

-Tony
